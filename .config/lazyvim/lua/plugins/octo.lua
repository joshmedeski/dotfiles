--[[
 ██████╗  ██████╗████████╗ ██████╗
██╔═══██╗██╔════╝╚══██╔══╝██╔═══██╗
██║   ██║██║        ██║   ██║   ██║
██║   ██║██║        ██║   ██║   ██║
╚██████╔╝╚██████╗   ██║   ╚██████╔╝
 ╚═════╝  ╚═════╝   ╚═╝    ╚═════╝
https://www.lazyvim.org/extras/util/octo 
LazyVim's Octo plugin for Git management with custom options and keybindings.
--]]

-- TODO: replace with gh.nvim?
-- https://github.com/ldelossa/gh.nvim
return {
  "pwntester/octo.nvim",
  config = {
    mappings = {
      review_diff = {
        -- NOTE: make it easy to switch between files while reviewing diffs
        select_next_entry = { lhs = "<Tab>", desc = "move to previous changed file" },
        select_prev_entry = { lhs = "<S-Tab>", desc = "move to next changed file" },
      },
    },
  },
  keys = {
    -- TODO: add this to the LazyVim extra (`<leader>go`?)
    { "<leader>o", "<cmd>Octo<cr>", desc = "Octo" },
  },
}
