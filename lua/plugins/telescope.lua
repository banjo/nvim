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
        "<leader>se",
        ":Telescope file_browser file_browser path=%:p:h=%:p:h<cr>",
        desc = "[s]earch [e]xplorer files",
      },
      {
        "<leader>fr",
        function()
          telescope.oldfiles({ only_cwd = true })
        end,
        desc = "[f]ind [r]ecent files",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = "Search buffer",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "[s]earch open files",
      },

      -- Remove or rename default commands
      { "<leader>ff", LazyVim.pick("auto"), desc = "[f]ind [f]iles" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[f]ind [g]it files" },
      { "<leader>fF", false },
      { "<leader>fG", false },
      { "<leader>fG", false },
      { "<leader>fR", false },
      { "<leader>sG", false },
      { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "[s]earch [g]rep" },
      { "<leader>fc", LazyVim.pick.config_files(), desc = "[f]ind [c]onfig files" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "[f]ind [b]uffer" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "[s]earch registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "[s]earch [a]uto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[s]earch [b]uffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "[s]earch [c]ommand History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "[s]earch [C]ommands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "[s]earch [d]ocument Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "[s]earch Workspace Diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[s]earch [h]elp pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "[s]earch Highlight groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[s]earch [k]ey maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "[s]earch [M]an pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "[s]earch [m]ark to jump" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "[s]earch [o]ptions" },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[s]earch [r]esume" },
      {
        "<leader>sw",
        LazyVim.pick("grep_string", { word_match = "-w", root = false }),
        desc = "[s]earch [w]ord",
      },
      {
        "<leader>sW",
        false,
      },
      {
        "<leader>sw",
        LazyVim.pick("grep_string", { root = false }),
        mode = "v",
        desc = "[s]earch [w]ord selection",
      },
      {
        "<leader>sW",
        false,
      },
      {
        "<leader>uC",
        false,
      },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "[s]earch [symbols]",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "[s]earch [S]ymbols (workspace)",
      },
      -- GIT
      {
        "<leader>gc",
        "<cmd>Telescope git_commits<cr>",
        desc = "[g]it [c]ommits",
      },
      {
        "<leader>gs",
        "<cmd>Telescope git_status<cr>",
        desc = "[g]it [s]tatus",
      },
      {
        "<leader>gB",
        "<cmd>Telescope git_branches<cr>",
        desc = "[g]it [B]ranches",
      },
      {
        "<leader>gS",
        "<cmd>Telescope git_stash<cr>",
        desc = "[g]it [S]tash",
      },
      {
        "<leader>sF",
        "<cmd>Telescope dir live_grep<CR>",
        desc = "[s]earch in [F]older",
      },
    },
    config = function(_, opts)
      require("telescope").load_extension("undo")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("dir")
    end,
  },
}
