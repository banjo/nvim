local M = {}

-- Find the project root directory by walking up the directory tree until a marker is found
local function find_root_dir(file_path, root_markers)
  local root_dir = vim.fn.fnamemodify(file_path, ":h") -- Start with buffer directory

  -- Walk up the directory tree until we find a marker
  while root_dir ~= "/" do
    local found = false
    for _, marker in ipairs(root_markers) do
      if vim.fn.isdirectory(root_dir .. "/" .. marker) == 1 or vim.fn.filereadable(root_dir .. "/" .. marker) == 1 then
        found = true
        break
      end
    end

    if found then
      break
    end

    -- Move up one directory
    root_dir = vim.fn.fnamemodify(root_dir, ":h")
  end

  return root_dir
end

local function extract_content_after_frontmatter(content)
  local frontmatter_end = 0

  -- Check if the file starts with frontmatter delimiter
  if content[1] and (content[1] == "---" or content[1] == "+++") then
    local delimiter = content[1]

    -- Find the end of the frontmatter
    for i = 2, #content do
      if content[i] == delimiter then
        frontmatter_end = i
        break
      end
    end
  end

  -- If frontmatter was found, return only the content after it
  if frontmatter_end > 0 then
    local result = {}
    for i = frontmatter_end + 1, #content do
      table.insert(result, content[i])
    end
    return result
  end

  -- If no frontmatter was found, return the original content
  return content
end

-- Parse frontmatter to extract glob patterns from a file's content
local function parse_glob_patterns(content)
  local patterns = {}
  local in_frontmatter = false

  for _, line in ipairs(content) do
    if line:match("^%-%-%-$") then
      if in_frontmatter then
        break
      else
        in_frontmatter = true
      end
    elseif in_frontmatter then
      local globs = line:match("^globs:%s*(.+)$")
      if globs then
        -- Handle array format: globs: ["pattern1", "pattern2"]
        if globs:match("^%[.+%]$") then
          -- Remove [ and ]
          local globs_content = globs:sub(2, -2)
          -- handles both ' and "
          for pattern_match in globs_content:gmatch("[\"']([^\"']+)[\"']") do
            table.insert(patterns, pattern_match)
          end
        else
          -- Handle simple string format: globs: pattern, removes quotes if present
          local clean_glob = globs:gsub("^[\"'](.+)[\"']$", "%1")
          table.insert(patterns, clean_glob)
        end
        break
      end
    end
  end

  return patterns
end

--- Scans a directory for rule files and extracts their patterns and content
--- @param rules_dir string The directory path to scan for rule files
--- @return RuleFile[] array of rule files found
local function scan_rule_files(rules_dir)
  local files = {}
  local scan_files = vim.fn.glob(rules_dir .. "/*", false, true)

  for _, file in ipairs(scan_files) do
    if vim.fn.isdirectory(file) == 0 then
      local content = vim.fn.readfile(file)
      local patterns = parse_glob_patterns(content)

      if #patterns > 0 then
        local filtered_content = extract_content_after_frontmatter(content)
        table.insert(files, { file = file, patterns = patterns, content = filtered_content })
      end
    end
  end

  return files
end

-- Get the content of files whose patterns match the current file
---@param rule_files RuleFile[] Array of rule files found
---@param file_name_from_root_dir string The name of the current file relative to the project root
---@return RuleFile[] Array of rule files whose patterns match the current file
local function get_matching_rule_files(rule_files, file_name_from_root_dir)
  local files = {}

  for _, file_entry in ipairs(rule_files) do
    if file_entry.patterns then
      for _, pattern in ipairs(file_entry.patterns) do
        local lpg = vim.glob.to_lpeg(pattern)
        local is_match = lpg:match(file_name_from_root_dir)
        if is_match then
          table.insert(files, file_entry)
        end
      end
    end
  end

  return files
end

---@class CodeCompanionRulesOptions
---@field rules_dir? string Directory containing rule files (default: ".cursor/rules")
---@field root_markers? string[] Markers to identify the project root (default: {".git"})

---@class RuleFile
---@field file string Path to the rule file
---@field patterns string[] Array of glob patterns parsed from the file
---@field content string[] Array of lines from the file with frontmatter removed

---@param file string Path to the current file
---@param opts? CodeCompanionRulesOptions Configuration options
---@return RuleFile[] Array of rule files found
function M.init(file, opts)
  opts = opts or {}
  local RULES_DIR = opts.rules_dir or ".cursor/rules"
  local ROOT_MARKERS = opts.root_markers or { ".git" }

  local root_dir = find_root_dir(file, ROOT_MARKERS)

  local absolute_rules_dir = root_dir .. "/" .. RULES_DIR

  if vim.fn.isdirectory(absolute_rules_dir) == 0 then
    vim.api.nvim_err_writeln("Rules directory does not exist")
    return {}
  end

  local rule_files = scan_rule_files(absolute_rules_dir)
  local file_name_from_root_dir = file:sub(#root_dir + 2)
  return get_matching_rule_files(rule_files, file_name_from_root_dir)
end

---@class FormatOpts
---@field prefix? string The prefix to use for the formatted string
---@field suffix? string The suffix to use for the formatted string
---@field separator? string The separator to use between each file content

---@param rule_files RuleFile[] Array of rule files found
---@param opts FormatOpts? Options for formatting the output
function M.format(rule_files, opts)
  opts = opts or {}
  opts.prefix = opts.prefix or "Here is context for the current file: \n\n---"
  opts.suffix = opts.suffix or "---\n\n"
  opts.separator = opts.separator or "\n---\n\n"

  if #rule_files == 0 then
    return ""
  end

  local contents = {}
  for _, rule_file in ipairs(rule_files) do
    local file_content = table.concat(rule_file.content, "\n")
    table.insert(contents, file_content)
  end

  local str = opts.prefix .. table.concat(contents, opts.separator) .. opts.suffix

  return str
end

return M
