return {
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-jest", "marilari88/neotest-vitest" },
    opts = function(_, opts)
      opts.log_level = vim.log.levels.INFO
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npx jest --runInBand", -- default jest command without watch
        })
      )
      table.insert(opts.adapters, require("neotest-vitest"))
    end,
  },
}
