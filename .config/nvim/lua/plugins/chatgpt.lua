return {
  "jackMort/ChatGPT.nvim",
  enabled = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = {
    "ChatGPT",
    "ChatGPTActAs",
    "ChatGPTCompleteCode",
    "ChatGPTEditWithInstructions",
    "ChatGPTRun",
  },

  config = function()
    require("chatgpt").setup({
      api_key_cmd = "op read op://Personal/ChatGPT/api_key --no-newline",
    })
  end,

  keys = function()
    local chatgpt = require("chatgpt")
    local wk = require("which-key")

    wk.register({
      a = {
        function()
          chatgpt.edit_with_instructions()
        end,
        "Edit with instructions",
      },
    }, {
      prefix = "<leader>",
      mode = "v",
    })

    return {
      { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
      { "<leader>ac", "<cmd>ChatGPTCompleteCode<cr>", desc = "ChatGPTCompleteCode" },
    }
  end,
}
