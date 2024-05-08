return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    local model = "gpt-4-turbo"
    local config = {
      openai_params = { model = model },
      openai_edit_params = { model = model },
      chat = {
        keymaps = {
          close = "q",
        },
      },
    }
    require("chatgpt").setup(config)
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
