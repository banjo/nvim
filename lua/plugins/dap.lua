return {
  "mfussenegger/nvim-dap",
  -- stylua: ignore
  keys = {
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<F5>", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Step Out" },
    -- revert step over and step out
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
  },
}
