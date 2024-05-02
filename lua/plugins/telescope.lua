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
    },
    keys = {
      { "<leader>fR", Util.telescope("resume"), desc = "Resume" },
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
    },
    config = function(_, opts)
      require("telescope").load_extension("undo")
      require("telescope").load_extension("file_browser")
    end,
  },
}
