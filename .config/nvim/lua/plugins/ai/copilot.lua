--[[

 ██████╗ ██████╗ ██████╗ ██╗██╗      ██████╗ ████████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔════╝██╔═══██╗██╔══██╗██║██║     ██╔═══██╗╚══██╔══╝████╗  ██║██║   ██║██║████╗ ████║
██║     ██║   ██║██████╔╝██║██║     ██║   ██║   ██║   ██╔██╗ ██║██║   ██║██║██╔████╔██║
██║     ██║   ██║██╔═══╝ ██║██║     ██║   ██║   ██║   ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╗╚██████╔╝██║     ██║███████╗╚██████╔╝   ██║██╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝    ╚═╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
Neovim plugin for GitHub Copilot

GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor. Trained on billions of lines of public code, GitHub Copilot turns natural language prompts including comments and method names into coding suggestions across dozens of languages.

Alternatives:
- [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) Integrates GitHub Copilot with nvim-cmp source
- [Tabnine](https://github.com/codota/tabnine-nvim) Tabnine AI-powered code completion
- [Codeium](https://github.com/Exafunction/codeium.nvim) Native support for Codeium's AI-powered coding assistant.
- [Minuet](https://github.com/milanglacier/minuet-ai.nvim) - AI-powered code completion for Neovim with support for multiple LLMs including OpenAI, Gemini, Claude, and more.

--]]

return {
  "github/copilot.vim",
  dependencies = { "catppuccin/nvim" },
  event = "VimEnter",
  init = function()
    vim.g.copilot_no_tab_map = false
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  end,
  keys = {
    { "<Tab>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true, mode = "i" } },
  },
}
