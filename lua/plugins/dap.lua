return {
  "mfussenegger/nvim-dap",

  opts = function(_, opts)
    local dap = require("dap")
    -- copied from LazyVim
    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

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
          name = "tsx",
          type = "node",
          request = "launch",
          program = "${file}",
          runtimeExecutable = "tsx",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
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
