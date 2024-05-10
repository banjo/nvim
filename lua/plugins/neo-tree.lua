return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      window = {
        mappings = {
          ["<space>"] = {
            "toggle_node",
          },
          ["h"] = { "toggle_node" },
          ["l"] = { "toggle_node" },
          ["p"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fE",
      false,
    },
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "[f]ind [explorer]",
    },
    { "<leader>E", false },
    { "<leader>e", "<leader>fe", desc = "[e]xplorer", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "[g]it [e]xplorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "[b]uffer [e]xplorer",
    },
  },
}
