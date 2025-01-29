--[[
 ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗██╗ ██████╗ ███╗   ██╗
██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   ██║██║   ██║██╔██╗ ██║
██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██║██║   ██║██║╚██╗██║
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   █║╚██████╔╝██║ ╚████║
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
Code completion is a feature in which the editor suggests completions for the current word 
or symbol. This can be helpful for writing code faster and with fewer errors. There are many
plugins available for code completion in Neovim.

My Choice:
[copilot.vim](https://github.com/github/copilot.vim) Built by Tim Pope (tpope) and uses the OpenAI Codex.

Alternatives:
- [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) Integrates GitHub Copilot with nvim-cmp source
- [Tabnine](https://github.com/codota/tabnine-nvim) Tabnine AI-powered code completion
- [Codeium](https://github.com/Exafunction/codeium.nvim) Codeium's AI-powered coding assistant
- [Minuet](https://github.com/milanglacier/minuet-ai.nvim) - Support for multiple LLMs

--]]

return {
  'github/copilot.vim',
  enabled = true,
  dependencies = { 'catppuccin/nvim' },
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    vim.g.copilot_no_tab_map = false
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  end,
  keys = {},
}
