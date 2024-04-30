return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
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
}
