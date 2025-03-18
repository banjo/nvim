return {
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        autostart = true,
        package_manager = "pnpm",
        hide_up_to_date = true,
      })
    end,
  },
}
