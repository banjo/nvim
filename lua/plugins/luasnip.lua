-- disable tab default behavior
return {
  "L3MON4D3/LuaSnip",
  opts = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  },
  config = function(_, opts)
    require("luasnip").config.set_config(opts)

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
  keys = function()
    return {}
  end,
}
