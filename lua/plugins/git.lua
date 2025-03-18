return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    -- config = true,
    config = function()
      vim.keymap.set("n", "<leader>gxc", "<Plug>(git-conflict-ours)", { desc = "current (ours)" })
      vim.keymap.set("n", "<leader>gxi", "<Plug>(git-conflict-theirs)", { desc = "incoming (theirs)" })
      vim.keymap.set("n", "<leader>gxb", "<Plug>(git-conflict-both)", { desc = "both" })
      vim.keymap.set("n", "<leader>gxn", "<Plug>(git-conflict-none)", { desc = "none" })
      vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "previous git conflict" })
      vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "next git conflict" })
      vim.keymap.set("n", "<leader>gxq", "<cmd>GitConflictListQf<CR>", { desc = "quicklist" })

      -- Define custom highlight groups for diff
      vim.api.nvim_set_hl(0, "CustomDiffCurrent", { fg = "#f8f8f2", bg = "#2a7a40" })
      vim.api.nvim_set_hl(0, "CustomDiffIncoming", { fg = "#f8f8f2", bg = "#4f5a83" })

      require("git-conflict").setup({
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = "CustomDiffCurrent",
          current = "CustomDiffIncoming",
        },
        default_mappings = false,
      })
    end,
  },
}
