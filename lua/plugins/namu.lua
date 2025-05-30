return {
  "bassamsdata/namu.nvim",
  config = function()
    require("namu").setup({
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        ---@type NamuConfig
        options = {
          AllowKinds = {
            default = {
              "Function",
              "Method",
              "Class",
              "Module",
              "Property",
              "Variable",
              -- "Constant",
              -- "Enum",
              -- "Interface",
              -- "Field",
              -- "Struct",
            },
          },
        },
      },
    })
    -- === Suggested Keymaps: ===
    vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
      desc = "Search Symbols Namu",
      silent = true,
      noremap = true,
    })
    -- vim.keymap.set("n", "<leader>th", ":Namu colorscheme<cr>", {
    --   desc = "Colorscheme Picker",
    --   silent = true,
    -- })
  end,
}
