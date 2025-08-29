return {
  'dmtrKovalenko/fff.nvim',
  enabled = true,
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
      height = 0.8,
      width = 0.8,
      prompt_position = 'top',
      preview_position = 'right',
      preview_size = 0.5,
    },
  },
  keys = {
    {
      'ff', -- try it if you didn't it is a banger keybinding for a picker
      function()
        local thing
        require('fff').find_files() -- or find_in_git_root() if you only want git files
      end,
      desc = 'Open file picker',
    },
  },
}
