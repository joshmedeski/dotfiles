--[[

 ██████╗ ██████╗ ██████╗ ██╗██╗      ██████╗ ████████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔════╝██╔═══██╗██╔══██╗██║██║     ██╔═══██╗╚══██╔══╝████╗  ██║██║   ██║██║████╗ ████║
██║     ██║   ██║██████╔╝██║██║     ██║   ██║   ██║   ██╔██╗ ██║██║   ██║██║██╔████╔██║
██║     ██║   ██║██╔═══╝ ██║██║     ██║   ██║   ██║   ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╗╚██████╔╝██║     ██║███████╗╚██████╔╝   ██║██╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝    ╚═╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
Neovim plugin for GitHub Copilot

GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor. Trained on billions of lines of public code, GitHub Copilot turns natural language prompts including comments and method names into coding suggestions across dozens of languages.

--]]

return {
  "github/copilot.vim",
  dependencies = { "catppuccin/nvim" },
  event = "VimEnter",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  end,
  {
    keys = {
      { "<Tab>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true, mode = "i" } },
    },
  },
}
