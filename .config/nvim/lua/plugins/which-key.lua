return {
  "folke/which-key.nvim",
  ---@class wk.Opts
  opts = {
    preset = "modern",
    ---@type wk.IconRule[]|false
    rules = {
      {
        pattern = "^Whisper[a-zA-Z0-9_]+$", -- match strings that begin with 'Whisper' followed by alphanumeric and underscores only
        icon = "",
      },
    },
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      },
      presets = {
        operators = false, -- adds help for operators like d, y, ...
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = false, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
  },
}
