return {
  {
    'echasnovski/mini.files',
    -- Navigate and manipulate file system. Part of 'mini.nvim' library.
    cmd = "MiniFiles",
    opts = {},
    keys = {
      { "-", "<cmd>lua MiniFiles.open()<cr>", desc = "list files" }
    }
  },
}
