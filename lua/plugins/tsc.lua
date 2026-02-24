return {
  "dmmulroy/tsc.nvim",
  config = function()
    require("tsc").setup()
  end,
  dependencies = {
    -- Optional: for better notifications
    -- "rcarriga/nvim-notify",
    -- Optional: for Trouble integration
    "folke/trouble.nvim",
  },
}
