return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {
    modes = {
      treesitter = {
        jump = { pos = "range", autojump = false },
      },
    },
  },
}
