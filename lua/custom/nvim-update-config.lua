local config_path = vim.fn.stdpath("config")

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level)
  end)
end

local function run_git(args, callback)
  local cmd = { "git", "-C", config_path }
  for _, arg in ipairs(args) do
    table.insert(cmd, arg)
  end

  vim.system(cmd, { text = true }, function(result)
    if result.code ~= 0 then
      callback(nil, result.stderr)
      return
    end

    callback(result.stdout, nil)
  end)
end

local function has_upstream(callback)
  run_git({ "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}" }, function(output, error)
    if error ~= nil then
      callback(false)
      return
    end

    callback(output ~= "")
  end)
end

local function is_clean(callback)
  run_git({ "status", "--porcelain" }, function(output, error)
    if error ~= nil then
      callback(false)
      return
    end

    callback(output == "")
  end)
end

local function fetch(callback)
  run_git({ "fetch" }, function(_, error)
    callback(error)
  end)
end

local function behind_count(callback)
  run_git({ "rev-list", "--count", "HEAD..@{u}" }, function(output, error)
    if error ~= nil then
      callback(0, error)
      return
    end

    local count = tonumber(vim.trim(output))
    callback(count or 0, nil)
  end)
end

local function pull_latest(options)
  is_clean(function(clean)
    if not clean then
      if options.notify_all then
        notify("NvimUpdateConfig: pull skipped (dirty)", vim.log.levels.WARN)
      end
      return
    end

    run_git({ "pull", "--ff-only" }, function(_, error)
      if error ~= nil then
        notify("NvimUpdateConfig: git pull failed", vim.log.levels.WARN)
        return
      end

      notify("NvimUpdateConfig: git pull ok", vim.log.levels.INFO)
    end)
  end)
end

local function notify_if_behind(options)
  has_upstream(function(upstream)
    if not upstream then
      if options.notify_all then
        notify("NvimUpdateConfig: no upstream", vim.log.levels.WARN)
      end
      return
    end

    fetch(function(fetch_error)
      if fetch_error ~= nil then
        if options.notify_all then
          notify("NvimUpdateConfig: git fetch failed", vim.log.levels.WARN)
        end
        return
      end

      behind_count(function(count)
        if count > 0 then
          notify(
            "NvimUpdateConfig: behind by " .. tostring(count) .. " commit(s). Run :NvimUpdateConfig",
            vim.log.levels.WARN
          )
          return
        end

        if options.notify_all then
          notify("NvimUpdateConfig: up to date", vim.log.levels.INFO)
        end
      end)
    end)
  end)
end

local function run_update(options)
  notify_if_behind(options)
  pull_latest(options)
end

local function setup()
  local group = vim.api.nvim_create_augroup("NvimUpdateConfig", { clear = true })

  vim.api.nvim_create_user_command("NvimUpdateConfig", function()
    run_update({ notify_all = true })
  end, {})

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
      vim.defer_fn(function()
        notify_if_behind({ notify_all = false })
      end, 500)
    end,
  })
end

setup()
