-- Biome linting integration
-- Runs biome lint on save when a biome.json/biome.jsonc exists in the project
-- Commands: :BiomeLint (lint), :BiomeLintFix (fix with --write --unsafe)

local function has_biome_config()
  local root = vim.fn.getcwd()
  return vim.fn.filereadable(root .. "/biome.json") == 1
    or vim.fn.filereadable(root .. "/biome.jsonc") == 1
end

local function get_biome_bin()
  local root = vim.fn.getcwd()
  local local_bin = root .. "/node_modules/.bin/biome"
  if vim.fn.executable(local_bin) == 1 then
    return local_bin
  end
  return "npx biome"
end

local function biome_lint(args)
  if not has_biome_config() then
    vim.notify("No biome.json(c) found in project root", vim.log.levels.WARN)
    return
  end

  local bin = get_biome_bin()
  local cmd = vim.list_extend(vim.split(bin, " "), { "lint", "--diagnostic-level=error", "--reporter=gitlab" })
  if args and args ~= "" then
    for _, arg in ipairs(vim.split(args, " ")) do
      table.insert(cmd, arg)
    end
  end
  table.insert(cmd, ".")

  vim.fn.setqflist({}, " ", { title = "Biome Lint" })

  vim.system(cmd, { text = true, cwd = vim.fn.getcwd() }, function(result)
    vim.schedule(function()
      local stdout = result.stdout or ""
      local stderr = result.stderr or ""

      -- Try to parse GitLab JSON reporter output
      local ok, diagnostics = pcall(vim.json.decode, stdout)
      if ok and type(diagnostics) == "table" and #diagnostics > 0 then
        local items = {}
        for _, d in ipairs(diagnostics) do
          table.insert(items, {
            filename = d.location and d.location.path or "",
            lnum = d.location and d.location.lines and d.location.lines.begin or 0,
            col = 0,
            text = (d.check_name or "") .. ": " .. (d.description or ""),
          })
        end
        vim.fn.setqflist(items, "r", { title = "Biome Lint" })
        vim.cmd("copen")
        vim.notify("Biome: " .. #items .. " error(s)", vim.log.levels.WARN)
      else
        vim.fn.setqflist({}, "r", { title = "Biome Lint" })
        if result.code == 0 then
          vim.notify("Biome: No lint errors", vim.log.levels.INFO)
        else
          vim.notify("Biome:\n" .. stderr, vim.log.levels.WARN)
        end
      end
    end)
  end)
end

local function biome_lint_fix(file, silent)
  if not has_biome_config() then
    if not silent then
      vim.notify("No biome.json(c) found in project root", vim.log.levels.WARN)
    end
    return
  end

  local target = file or "."
  local bin = get_biome_bin()
  local cmd = vim.list_extend(vim.split(bin, " "), { "check", "--diagnostic-level=error", "--write", "--unsafe", target })

  if not silent then
    vim.notify("Biome: fixing...", vim.log.levels.INFO)
  end
  vim.system(cmd, { text = true, cwd = vim.fn.getcwd() }, function(result)
    vim.schedule(function()
      vim.cmd("checktime")
      if result.code ~= 0 then
        local output = (result.stdout or "") .. (result.stderr or "")
        vim.notify("Biome fix:\n" .. output, vim.log.levels.WARN)
      elseif not silent then
        vim.notify("Biome: fix complete", vim.log.levels.INFO)
      end
    end)
  end)
end

return {
  dir = ".",
  name = "biome-lint-custom",
  lazy = false,
  config = function()
    vim.api.nvim_create_user_command("BiomeLint", function(opts)
      biome_lint(opts.args)
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("BiomeLintFix", function()
      biome_lint_fix()
    end, {})

    -- Auto-fix on save for biome projects
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("BiomeLintOnSave", { clear = true }),
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.json", "*.jsonc" },
      callback = function(ev)
        if has_biome_config() then
          biome_lint_fix(ev.file, true)
        end
      end,
    })
  end,
}
