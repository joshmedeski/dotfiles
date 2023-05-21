return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = "neovim/nvim-lspconfig",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      debounce = 150,
      save_after_format = false,
      sources = {
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.diagnostics.cspell,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.mdformat,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
        }),
      },
      root_dir = require("null-ls.utils").root_pattern("package.json", ".null-ls-root", ".neoconf.json", ".git"),
    })
  end,
}
