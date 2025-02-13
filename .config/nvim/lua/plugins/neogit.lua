return {
  'NeogitOrg/neogit',
  cmd = 'Neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    integrations = {
      telescope = true,
      diffview = true,
    },
    graph_style = 'unicode',
    commit_editor = {
      kind = 'tab',
      show_staged_diff = true,
      staged_diff_split_kind = 'auto',
      spell_check = true,
    },
    signs = {
      hunk = { '', '' },
      item = { '▸', '▾' },
      section = { '▷', '▽' },
    },
    sections = {
      recent = {
        folded = false,
        hidden = false,
      },
    },
  },
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neo[g]it Dashboard' },
    { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Neo[g]it [c]ommit' },
  },
}
