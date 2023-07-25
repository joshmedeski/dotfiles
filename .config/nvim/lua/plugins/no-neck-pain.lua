return {
  "shortcuts/no-neck-pain.nvim",
  cmd = { "NoNeckPain", "NoNeckPainResize", "NoNeckPainWidthUp", "NoNeckPainWidthDown" },
  config = function()
    require("no-neck-pain").setup({})
  end,
}
