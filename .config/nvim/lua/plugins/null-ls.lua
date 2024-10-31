return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  dependencies = "neovim/nvim-lspconfig",
  config = function()
    local null_ls = require("null-ls")

    local function get_markdownlint_config_path()
      local cwd = vim.fn.getcwd()
      local config_path = cwd .. "/.markdownlint.json"
      local fallback_path = vim.fn.expand("~/.config/nvim/.markdownlint.json")

      if vim.fn.filereadable(config_path) == 1 then
        return config_path
      elseif vim.fn.filereadable(fallback_path) == 1 then
        return fallback_path
      else
        return nil
      end
    end

    null_ls.setup({
      debounce = 150,
      save_after_format = false,
      sources = {
        -- TODO: migrate linters to nvim-lint
        -- TODO: migrate formatters to conform.nvim
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.diagnostics.cspell,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.markdownlint.with({
          extra_args = function()
            local config_path = get_markdownlint_config_path()
            if config_path then
              return { "--config", config_path }
            else
              return {}
            end
          end,
        }),
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
