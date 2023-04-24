return {
  "axkirillov/hbac.nvim",
  config = function()
    require("hbac").setup({
      autoclose = true,
      threshold = 60,
    })
  end,
}
