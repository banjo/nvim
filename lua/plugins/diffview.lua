return {
  "sindrets/diffview.nvim",
  config = function()
    vim.keymap.set("n", "<leader>gdx", "<cmd>tabc<CR>", { desc = "close" })
    vim.keymap.set("n", "<leader>gdr", "<cmd>DiffviewFileHistory<cr>", { desc = "repo history" })
    vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "file history" })
    vim.keymap.set("v", "<leader>gdR", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", { desc = "range history" })
    vim.keymap.set("n", "<leader>gdl", "<Cmd>.DiffviewFileHistory --follow<CR>", { desc = "line history" })

    vim.keymap.set("n", "<leader>gdr", "<cmd>DiffviewOpen<cr>", { desc = "repo diff" })

    local function get_default_branch_name()
      local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
      return res.code == 0 and "main" or "master"
    end

    -- Diff against remote master branch
    vim.keymap.set("n", "<leader>gdm", function()
      vim.cmd("DiffviewOpen HEAD..origin/" .. get_default_branch_name())
    end, { desc = "diff against origin/master" })

    -- Diff against develop
    vim.keymap.set("n", "<leader>gdd", function()
      vim.cmd("DiffviewOpen HEAD..origin/develop")
    end, { desc = "diff against develop" })
  end,
}
