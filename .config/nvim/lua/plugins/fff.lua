return {
  'dmtrKovalenko/fff.nvim',
  cmd = {
    'FFFFind',
    'FFFScan',
    'FFFRefreshGit',
    'FFFClearCache',
    'FFFHealth',
    'FFFDebug',
    'FFFOpenLog',
  },
  build = 'cargo build --release',
  opts = {
    layout = {
      height = 0.9,
      width = 0.8,
      prompt_position = 'top',
      preview_position = 'right',
      preview_size = 0.6,
    },
  },
  keys = {
    {
      'ff', -- try it if you didn't it is a banger keybinding for a picker
      function()
        require('fff').find_files() -- or find_in_git_root() if you only want git files
      end,
      desc = 'Open file picker',
    },
  },
}
