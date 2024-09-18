return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  keys = {
    {
      "e",
      function()
        require("spider").motion("e")
      end,
    },
    {
      "b",
      function()
        require("spider").motion("b")
      end,
    },
    {
      "w",
      function()
        require("spider").motion("w")
      end,
    },
  },
  config = function()
    require("spider").setup({
      skipInsignificantPunctuation = false,
      subwordMovement = true,
    })
  end,
}
