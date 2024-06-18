return {
  {
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        overrides = function(colors)
          return {
            NormalFloat = { fg = colors.fg, bg = colors.menu },
          }
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
