return {
  "sindrets/diffview.nvim",
  config = function()
    -- Update color for DiffView
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#f1fa8c", fg = "#282a36" }) -- yellow bg, dark text
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#ffb86c", fg = "#282a36", bold = true }) -- orange bg, dark text, bold

    vim.keymap.set("n", "<leader>gdx", "<cmd>tabc<CR>", { desc = "Close" })
    vim.keymap.set("n", "<leader>gdr", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo History" })
    vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File History" })
    vim.keymap.set("v", "<leader>gdR", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", { desc = "Range History" })
    vim.keymap.set("n", "<leader>gdl", "<Cmd>.DiffviewFileHistory --follow<CR>", { desc = "Line History" })

    vim.keymap.set("n", "<leader>gdd", "<cmd>DiffviewOpen<cr>", { desc = "Diff" })

    local function get_default_branch_name()
      local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
      return res.code == 0 and "main" or "master"
    end

    -- Diff against remote master branch
    vim.keymap.set("n", "<leader>gdm", function()
      vim.cmd("DiffviewOpen HEAD..origin/" .. get_default_branch_name())
    end, { desc = "Diff Origin/Master" })

    -- Diff against develop
    vim.keymap.set("n", "<leader>gdD", function()
      vim.cmd("DiffviewOpen HEAD..origin/develop")
    end, { desc = "Diff Develop" })

    -- Diff against custom branch with Telescope branch picker
    vim.keymap.set("n", "<leader>gdb", function()
      -- Get all remote branches sorted by latest commit
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
            entry_maker = function(branch)
              return {
                value = branch,
                display = branch,
                ordinal = branch,
              }
            end,
          }),
          sorter = require("telescope.config").values.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            require("telescope.actions").select_default:replace(function()
              local selection = require("telescope.actions.state").get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)

              if selection then
                -- Open the diff view with the selected branch
                vim.cmd("DiffviewOpen HEAD.." .. selection.value)
              end
            end)
            return true
          end,
          previewer = require("telescope.previewers").new_buffer_previewer({
            title = "Branch Details",
            define_preview = function(self, entry, status)
              local branch = entry.value

              -- Get commit information for preview
              local preview_job = vim
                .system({
                  "git",
                  "log",
                  "-1",
                  "--pretty=format:Author: %an%nEmail: %ae%nDate: %ar%n%nMessage: %s%n%n%b",
                  branch,
                }, { text = true })
                :wait()

              if preview_job.code == 0 then
                -- Add branch name as the first line
                local preview_text = "Branch: " .. branch .. "\n\n" .. preview_job.stdout
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(preview_text, "\n"))
              else
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Failed to load branch details" })
              end
            end,
          }),
        })
        :find()
    end, { desc = "Diff Remote Branch" })
  end,
}
