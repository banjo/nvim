local files = require("utils.files")
local table_util = require("utils.table")

---@type table<string, string[]>
local mgr_lockfiles = {
  npm = { "package-lock.json" },
  pnpm = { "pnpm-lock.yaml" },
  yarn = { "yarn.lock" },
  bun = { "bun.lockb", "bun.lock" },
}

---@type table<string, string>
local run_commands = {
  npm = "npm run",
  pnpm = "pnpm run",
  yarn = "yarn",
  bun = "bun",
}

---@class SearchParams
---@field filetype? string
---@field tags? string[]
---@field dir string

---@param opts SearchParams
local function get_candidate_package_files(opts)
  -- Some projects have package.json files in subfolders, which are not the main project package.json file,
  -- but rather some submodule marker. This seems prevalent in react-native projects. See this for instance:
  -- https://stackoverflow.com/questions/51701191/react-native-has-something-to-use-local-folders-as-package-name-what-is-it-ca
  -- To cover that case, we search for package.json files starting from the current file folder, up to the
  -- working directory
  local matches = vim.fs.find("package.json", {
    upward = true,
    type = "file",
    path = opts.dir,
    stop = vim.fn.getcwd() .. "/..",
    limit = math.huge,
  })
  if #matches > 0 then
    return matches
  end
  -- we couldn't find any match up to the working directory.
  -- let's now search for any possible single match without
  -- limiting ourselves to the working directory.
  return vim.fs.find("package.json", {
    upward = true,
    type = "file",
    path = vim.fn.getcwd(),
  })
end

---@param opts SearchParams
---@return string|nil
local function find_package_file(opts)
  local candidate_packages = get_candidate_package_files(opts)
  -- go through candidate package files from closest to the file to least close
  for _, package in ipairs(candidate_packages) do
    local data = files.load_json_file(package)
    if data.scripts or data.workspaces then
      return package
    end
  end
  return nil
end

local function detect_package_manager(package_file)
  local package_dir = vim.fs.dirname(package_file)
  for mgr, lockfiles in pairs(mgr_lockfiles) do
    if
      table_util.list_any(lockfiles, function(lockfile)
        return files.exists(files.join(package_dir, lockfile))
      end)
    then
      return mgr
    end
  end
  return "npm"
end

---@param package string -- path to package.json file
---@return string[]
local function get_all_scripts(package)
  local data = files.load_json_file(package)
  local ret = {}
  if data.scripts then
    for script in pairs(data.scripts) do
      table.insert(ret, script)
    end
  end

  -- Load tasks from workspaces
  if data.workspaces then
    for _, workspace in ipairs(data.workspaces) do
      local workspace_path = files.join(vim.fs.dirname(package), workspace)
      local workspace_package_file = files.join(workspace_path, "package.json")
      local workspace_data = files.load_json_file(workspace_package_file)
      if workspace_data and workspace_data.scripts then
        for script in pairs(workspace_data.scripts) do
          table.insert(ret, script)
        end
      end
    end
  end
  return ret
end

local function get_run_command(package_manager)
  local cmd = run_commands[package_manager]

  if not cmd then
    return run_commands.npm
  end

  return cmd
end

return {
  get_all_scripts = get_all_scripts,
  find_package_file = find_package_file,
  detect_package_manager = detect_package_manager,
  get_run_command = get_run_command,
}
