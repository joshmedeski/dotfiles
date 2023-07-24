return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions", "ChatGPTRun" },
  config = function()
    require("chatgpt").setup({
      api_key_cmd = "op read op://Personal/ChatGPT/api_key --no-newline",
    })
  end,
}
