return {
  "jackMort/ChatGPT.nvim",
  enabled = true,
  cmd = { "ChatGPT" },
  config = function()
    require("chatgpt").setup({
      api_key_cmd = "op read op://Personal/ChatGPT/api_key --no-newline",
      openai_params = {
        model = "gpt-3.5-turbo",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 1000,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  keys = function()
    require("which-key").add({
      { "<leader>m", group = "ChatGPT", icon = "󰧑" },
      { "<leader>mc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      {
        mode = { "n", "v" },
        { "<leader>ma", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
        { "<leader>md", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
        { "<leader>me", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
        { "<leader>mf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
        { "<leader>mg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
        { "<leader>mk", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
        { "<leader>ml", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
        { "<leader>mo", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
        { "<leader>mr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
        { "<leader>ms", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
        { "<leader>mt", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
        { "<leader>mx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
      },
    })
  end,
}

-- return {
--   "jackMort/ChatGPT.nvim",
--   enabled = true,
--   dependencies = {
--     "MunifTanjim/nui.nvim",
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   cmd = {
--     "ChatGPT",
--     "ChatGPTActAs",
--     "ChatGPTCompleteCode",
--     "ChatGPTEditWithInstructions",
--     "ChatGPTRun",
--   },
--
--   config = function()
--     require("chatgpt").setup({
--       api_key_cmd = "op read op://Personal/ChatGPT/api_key --no-newline",
--     })
--   end,
--
--   keys = function()
--     local chatgpt = require("chatgpt")
--     local wk = require("which-key")
--
--     wk.register({
--       a = {
--         function()
--           chatgpt.edit_with_instructions()
--         end,
--         "Edit with instructions",
--       },
--     }, {
--       prefix = "<leader>",
--       mode = "v",
--     })
--
--     return {
--       { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
--       { "<leader>ac", "<cmd>ChatGPTCompleteCode<cr>", desc = "ChatGPTCompleteCode" },
--     }
--   end,
-- }
