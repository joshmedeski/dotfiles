-- cSpell:words weilbith
-- TODO: replace with Noice?
return {
  "weilbith/nvim-code-action-menu",
  enabled = false,
  cmd = "CodeActionMenu",
  keys = {
    { "<leader><space>", "<cmd>CodeActionMenu<cr>", { desc = "Code Action Menu" } },
  },
}
