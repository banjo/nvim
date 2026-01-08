local function pick_script()
  local pilot = require("package-pilot")

  local current_dir = vim.fn.getcwd()
  local package = pilot.find_package_file({ dir = current_dir })

  if not package then
    vim.notify("No package.json found", vim.log.levels.ERROR)
    return require("dap").ABORT
  end

  local scripts = pilot.get_all_scripts(package)

  local label_fn = function(script)
    return script
  end

  local co, ismain = coroutine.running()
  local ui = require("dap.ui")
  local pick = (co and not ismain) and ui.pick_one or ui.pick_one_sync
  local result = pick(scripts, "Select script", label_fn)
  return result or require("dap").ABORT
end

return {
  "mfussenegger/nvim-dap",

  opts = function(_, opts)
    local dap = require("dap")
    -- copied from LazyVim
    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

    local current_file = vim.fn.expand("%:t")

    -- Add new base configurations, override the default ones
    for _, language in ipairs(js_filetypes) do
      dap.configurations[language] = {
        {
          name = "----- ↓ default configs ↓ -----",
          type = "",
          request = "launch",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          name = "tsx (" .. current_file .. ")",
          type = "node",
          request = "launch",
          program = "${file}",
          runtimeExecutable = "tsx",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
        },
        {
          name = "Debug Jest (current file)",
          type = "node",
          request = "launch",
          runtimeExecutable = "node",
          runtimeArgs = {
            "--inspect-brk",
            "${workspaceFolder}/node_modules/.bin/jest",
            "${file}",
            "--runInBand",
          },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
        },
        {
          name = "Debug vitest (current file)",
          type = "node",
          request = "launch",
          runtimeExecutable = "npx",
          runtimeArgs = {
            "vitest",
            "run",
            "--inspect",
            "--no-file-parallelism",
            "${file}",
          },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
        },

        {
          type = "node",
          request = "launch",
          name = "unify-mono: ecoa-pod",
          runtimeExecutable = "pnpm",
          runtimeArgs = { "run", "start:ecoa-jobs-be" },
          cwd = "${workspaceFolder}",
        },
        {
          type = "node",
          request = "launch",
          name = "pick script (pnpm)",
          runtimeExecutable = "pnpm",
          runtimeArgs = { "run", pick_script },
          cwd = "${workspaceFolder}",
        },
        {
          type = "node",
          request = "launch",
          name = "pick script (npm)",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", pick_script },
          cwd = "${workspaceFolder}",
        },
        -- Divider for the launch.json derived configs
        {
          name = "----- ↓ launch.json configs ↓ -----",
          type = "",
          request = "launch",
        },
      }
    end
  end,
  keys = {
    {
      "<F9>",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Run/Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<S-F11>",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    -- revert step over and step out
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
  },
}
