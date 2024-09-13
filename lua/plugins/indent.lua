return {
  "nmac427/guess-indent.nvim",
  config = function()
    require("guess-indent").setup({
      ignore_ft = { "markdown" },
      override_editorconfig = true,
    })
  end,
}
