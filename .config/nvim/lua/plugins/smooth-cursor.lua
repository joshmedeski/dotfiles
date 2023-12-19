return {
  "gen740/SmoothCursor.nvim",
  enabled = false,
  config = function()
    require("smoothcursor").setup({
      cursor = "👉",
      fancy = {
        enable = false,
        head = { cursor = "👉" },
      },
    })
  end,
}
