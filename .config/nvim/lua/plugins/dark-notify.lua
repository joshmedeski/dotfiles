return {
  "cormacrelf/dark-notify",
  init = function()
    require("dark_notify").run()
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function()
        vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
      end,
    })
  end,
}
