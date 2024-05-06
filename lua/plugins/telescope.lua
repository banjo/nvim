local Util = require("lazyvim.util")
local telescope = require("telescope.builtin")

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      {
        "<leader>sf",
        ":Telescope file_browser file_browser path=%:p:h=%:p:h<cr>",
        desc = "Search files",
      },
      {
        "<leader>fr",
        function()
          telescope.oldfiles({ only_cwd = true })
        end,
        desc = "Find recent files",
      },
      {
        "<leader><leader>",
        function()
          telescope.oldfiles({ only_cwd = true })
        end,
        desc = "Find recent files",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = "Search in current buffer",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "Live grep in open files",
      },
    },
    config = function(_, opts)
      require("telescope").load_extension("undo")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}
