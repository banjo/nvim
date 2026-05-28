return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    vim.g.opencode_opts = {
      ask = {
        completion = false,
        snacks = {
          win = {
            b = {
              completion = false,
            },
            on_buf = function() end,
          },
        },
      },
    }
    vim.o.autoread = true
  end,
  keys = {
    {
      "<leader>aa",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle opencode",
      mode = { "n", "t" },
    },
    {
      "<leader>aq",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "Quick chat",
      mode = { "n", "x" },
    },
    {
      "<leader>ap",
      function()
        require("opencode").select()
      end,
      desc = "Prompt",
      mode = { "n", "x" },
    },
    {
      "<leader>as",
      function()
        require("opencode").command("session.select")
      end,
      desc = "Select session",
    },
    {
      "<leader>an",
      function()
        require("opencode").command("session.new")
      end,
      desc = "New session",
    },
  },
}
