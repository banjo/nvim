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
      "nvim-telescope/telescope-node-modules.nvim",
    },
    keys = {
      {
        "<leader>se",
        ":Telescope file_browser file_browser path=%:p:h=%:p:h<cr>",
        desc = "Search Explorer Files",
      },
      {
        "<leader>sN",
        "<cmd>Telescope node_modules list<cr>",
        desc = "Search node_modules",
      },
      {
        "<leader>fr",
        function()
          telescope.oldfiles({ only_cwd = true })
        end,
        desc = "Find Recent Files",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = "Search Buffer",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "Search Open Files",
      },

      -- Remove or rename default commands
      { "<leader>ff", LazyVim.pick("auto"), desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Git Files" },
      { "<leader>fF", false },
      { "<leader>fG", false },
      { "<leader>fG", false },
      { "<leader>fR", false },
      { "<leader>sG", false },
      { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Search Grep" },
      {
        "<leader>sG",
        LazyVim.pick("live_grep", {
          root = false,
          additional_args = function()
            local constants = require("utils.constants")
            local args = {}
            for _, pat in ipairs(constants.shared_glob_patterns) do
              table.insert(args, "--glob")
              table.insert(args, pat)
            end
            return args
          end,
        }),
        desc = "Search Grep (with filters)",
      },
      { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config Files" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffer" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Search Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Search Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Search Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Search Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Search Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Search Workspace Diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Search Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Search Mark to Jump" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Search Options" },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Search Resume" },
      {
        "<leader>sw",
        LazyVim.pick("grep_string", { word_match = "-w", root = false }),
        desc = "Search Word",
      },
      {
        "<leader>sW",
        false,
      },
      {
        "<leader>sw",
        LazyVim.pick("grep_string", { root = false }),
        mode = "v",
        desc = "Search Word Selection",
      },
      {
        "<leader>sW",
        false,
      },
      {
        "<leader>uC",
        false,
      },
      -- REPLACED by Namu
      -- {
      --   "<leader>ss",
      --   function()
      --     require("telescope.builtin").lsp_document_symbols({
      --       symbols = require("lazyvim.config").get_kind_filter(),
      --     })
      --   end,
      --   desc = "[s]earch [s]ymbols",
      -- },
      {
        "<leader>ss",
        false,
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "Search Symbols Workspace",
      },
      -- GIT
      {
        "<leader>gc",
        "<cmd>Telescope git_commits<cr>",
        desc = "Git Commits",
      },
      {
        "<leader>gs",
        "<cmd>Telescope git_status<cr>",
        desc = "Git Status",
      },
      {
        "<leader>gB",
        "<cmd>Telescope git_branches<cr>",
        desc = "Git Branches",
      },
      {
        "<leader>gS",
        "<cmd>Telescope git_stash<cr>",
        desc = "Git Stash",
      },
      {
        "<leader>sF",
        "<cmd>Telescope dir live_grep<CR>",
        desc = "Search in Folder",
      },
    },
    config = function(_, opts)
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              preview_cutoff = 0, -- Show the preview window at the top
              preview_height = 0.5, -- Adjust the height of the preview window
            },
          },
          file_ignore_patterns = { "node_modules/.*" },
        },
        pickers = {
          find_files = {
            hidden = true, -- Include hidden files
          },
        },
      })
      require("telescope").load_extension("undo")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("node_modules")
    end,
  },
}
