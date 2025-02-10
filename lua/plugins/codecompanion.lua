return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local codecompanion = require("codecompanion")
      codecompanion.setup({
        strategies = {
          chat = {
            keymaps = {
              close = {
                modes = { n = { "q", "<C-c>" }, i = "<C-c>" },
              },
            },
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
      })
    end,
    keys = {
      {
        "<leader>aa",
        function()
          require("codecompanion").chat({})
        end,
        desc = "[a]i ch[a]t",
        mode = { "n", "v" },
      },
      {
        desc = "[a]i [q]uick chat",
        "<leader>aq",
        function()
          vim.cmd(":CodeCompanion /buffer")
        end,
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        function()
          require("codecompanion").actions({})
        end,
        desc = "[a]i [c]ommands",
        mode = { "n", "v" },
      },
    },
  },
}
