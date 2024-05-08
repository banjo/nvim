return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    local model = "gpt-4-turbo"
    local close_key = "q"

    local config = {
      openai_params = { model = model },
      openai_edit_params = { model = model },
      edit_with_instructions = {
        keymaps = {
          close = close_key,
        },
      },
      chat = {
        keymaps = {
          close = close_key,
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
