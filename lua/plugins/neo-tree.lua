local function copy_path(state)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ":."),
    modify(filepath, ":~"),
    filename,
    modify(filename, ":r"),
    modify(filename, ":e"),
  }

  vim.ui.select({
    "1. Absolute path: " .. results[1],
    "2. Path relative to CWD: " .. results[2],
    "3. Path relative to HOME: " .. results[3],
    "4. Filename: " .. results[4],
    "5. Filename without extension: " .. results[5],
    "6. Extension of the filename: " .. results[6],
  }, { prompt = "Choose to copy to clipboard:" }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg('"', result)
        vim.fn.setreg("+", result)
        vim.fn.setreg("*", result)
        vim.notify("Copied: " .. result)
      else
        vim.notify("Invalid selection")
      end
    else
      vim.notify("Selection cancelled")
    end
  end)
end

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
          ["Y"] = copy_path,
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
