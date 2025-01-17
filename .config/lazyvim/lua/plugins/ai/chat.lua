--[[
 ██████╗██╗  ██╗ █████╗ ████████╗
██╔════╝██║  ██║██╔══██╗╚══██╔══╝
██║     ███████║███████║   ██║
██║     ██╔══██║██╔══██║   ██║
╚██████╗██║  ██║██║  ██║   ██║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
AI Chat in the editor is a feature that allows you to chat with an
AI assistant directly in your editor. This can be helpful for generating
code snippets, writing documentation, or even just having a conversation.

My Choice:
- [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) A Github Copilot chat interface

Alternatives:
- [avante.nvim](https://github.com/yetone/avante.nvim) Emulates Cursor AI IDE behavior
- [ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim) Effortless natural language generation

--]]

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  -- NOTE: configured via LazyVim 💤
  -- https://www.lazyvim.org/extras/ai/copilot-chat
  -- {
  prompts = {
    Yarrr = {
      system_prompt = "You are fascinated by pirates, so please respond in pirate speak.",
    },
    Ghostty = {
      description = "My custom prompt description",
      prompt = [=[
      > #url https://ghostty.org/docs/config/reference
      ]=],
    },
  },
}
