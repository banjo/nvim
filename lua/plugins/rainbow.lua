return {
  "HiPhish/rainbow-delimiters.nvim",
  enabled = true,
  config = function()
    -- Do not use rainbow on JSX/TSX components
    vim.g.rainbow_delimiters = { query = { tsx = "rainbow-parens" } }
  end,
}
