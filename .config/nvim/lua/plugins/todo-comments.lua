--[[

 ████████╗ ██████╗ ██████╗  ██████╗      ██████╗ ██████╗ ███╗   ███╗███╗   ███╗███████╗███╗   ██╗████████╗███████╗
 ╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
    ██║   ██║   ██║██║  ██║██║   ██║    ██║     ██║   ██║██╔████╔██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████╗
    ██║   ██║   ██║██║  ██║██║   ██║    ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║
    ██║   ╚██████╔╝██████╔╝╚██████╔╝    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ███████║
    ╚═╝    ╚═════╝ ╚═════╝  ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝

    ✅ Highlight, list and search todo comments in your projects

    Examples:

     PERF: fully optimised
     HACK: hmmm, this looks a bit funky
     TODO: What else?
     NOTE: adding a note
     FIX: this needs fixing
     WARNING: ???

--]]

return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
  },
  keys = {
    {
      ']t',
      function()
        require('todo-comments').jump_next()
      end,
      desc = 'Next todo comment',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'Previous todo comment',
    },
    {
      '<leader>TA',
      '<cmd>TodoTelescope<CR>',
      desc = 'TodoTelescope',
    },
    {
      '<leader>TT',
      '<cmd>TodoTelescope keywords=TODO,FIX<CR>',
      desc = 'TodoTelescope',
    },
  },
}
