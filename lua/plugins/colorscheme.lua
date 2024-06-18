return {
  {
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        -- not needed now since noice has been updated with signature borders
        -- overrides = function(colors)
        --   return {
        --     NormalFloat = { fg = colors.fg, bg = colors.menu },
        --   }
        -- end,
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
