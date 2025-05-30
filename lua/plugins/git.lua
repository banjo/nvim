return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      vim.keymap.set("n", "<leader>gxc", "<Plug>(git-conflict-ours)", { desc = "Current (Ours)" })
      vim.keymap.set("n", "<leader>gxi", "<Plug>(git-conflict-theirs)", { desc = "Incoming (Theirs)" })
      vim.keymap.set("n", "<leader>gxb", "<Plug>(git-conflict-both)", { desc = "Both" })
      vim.keymap.set("n", "<leader>gxn", "<Plug>(git-conflict-none)", { desc = "None" })
      vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous Conflict" })
      vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Next Conflict" })
      vim.keymap.set("n", "<leader>gxq", "<cmd>GitConflictListQf<CR>", { desc = "Quicklist" })

      vim.keymap.set("n", "<leader>gxs", function()
        local actions = {
          GitConflictCurrent = "ours",
          GitConflictCurrentLabel = "ours",
          GitConflictAncestor = "base",
          GitConflictAncestorLabel = "base",
          GitConflictIncoming = "theirs",
          GitConflictIncomingLabel = "theirs",
        }
        local mark = vim.iter(vim.inspect_pos().extmarks):find(function(e)
          return e.ns == "git-conflict" and actions[e.opts.hl_group]
        end)
        if not mark then
          vim.notify("No conflict under cursor", vim.log.levels.WARN)
          return
        end
        require("git-conflict").choose(actions[mark.opts.hl_group])
      end, { desc = "Select Under Cursor" })

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
