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

    -- Diff against custom branch with Telescope branch picker
    vim.keymap.set("n", "<leader>gdb", function()
      local fetch_job = vim
        .system(
          { "git", "for-each-ref", "--sort=-committerdate", "refs/remotes/", "--format=%(refname:short)" },
          { text = true }
        )
        :wait()

      if fetch_job.code ~= 0 then
        vim.notify("Failed to fetch remote branches", vim.log.levels.ERROR)
        return
      end

      -- Split the output into lines and filter out empty lines
      local branches = {}
      for line in fetch_job.stdout:gmatch("[^\r\n]+") do
        table.insert(branches, line)
      end

      if #branches == 0 then
        vim.notify("No remote branches found", vim.log.levels.WARN)
        return
      end

      -- Use Telescope to pick a branch
      require("telescope.pickers")
        .new({}, {
          prompt_title = "Remote Branches (Sorted by Latest Commit)",
          finder = require("telescope.finders").new_table({
            results = branches,
          }),
          sorter = require("telescope.config").values.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            require("telescope.actions").select_default:replace(function()
              local selection = require("telescope.actions.state").get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)

              if selection then
                local branch = selection.value
                local branch_name = branch:match("^[^/]+/(.+)$") or branch

                vim.cmd("DiffviewOpen HEAD.." .. branch_name)
              end
            end)
            return true
          end,
        })
        :find()
    end, { desc = "diff against custom remote branch" })
  end,
}
