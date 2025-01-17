return {
  "glacambre/firenvim",
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  -- config = function()
  --   vim.g.firenvim_config = {
  --     localSettings = {
  --       [".*"] = {
  --         takeover = "never",
  --       },
  --     },
  --   }
  -- end,
  setup = function()
    vim.g.firenvim_config.localSettings[".*"] = { takeover = "never" }
  end,
}
