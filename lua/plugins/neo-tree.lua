return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          --auto close
          require("neo-tree").close_all()
        end,
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false, -- should not hide certain files
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
        },
        always_show = {
          ".env",
        },
      },
      window = {
        mappings = {
          ["<space>"] = {
            "toggle_node",
          },
          ["h"] = { "toggle_node" },
          ["l"] = { "toggle_node" },
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          -- Aider related mappings are handled in aider.lua via opts function
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
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd(), position = "left" })
      end,
      desc = "Find Explorer",
    },
    { "<leader>E", false },
    { "<leader>e", "<leader>fe", desc = "Explorer", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
}
