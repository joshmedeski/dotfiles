local lsp = require("lsp-zero")
require("neodev").setup({})
require("lspconfig.ui.windows").default_options.border = "double"

lsp.preset("recommended")

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = { error = "", warn = "", hint = "﨧", info = "" },
})

lsp.on_attach(function(_, bufnr)
  vim.keymap.set("n", "gd", require("joshmedeski/go_to_def").go_to_def, {
    buffer = bufnr,
    remap = false,
    desc = "Go to definition",
  })
end)

require("packer").use({ "mtoohey31/cmp-fish", ft = "fish" })

lsp.setup_nvim_cmp({
  sources = {
    { name = "nvim_lsp", group_index = 1 },
    { name = "buffer", group_index = 2 },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
    { name = "spell" },
    { name = "fish" },
    { name = "tmux" },
    { name = "conventionalcommits" },
  },
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

local lspkind = require("lspkind")
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  formatting = {
    format = function(entry, vim_item)
      if vim.tbl_contains({ "path" }, entry.source.name) then
        local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
          return vim_item
        end
      end
      return lspkind.cmp_format()(entry, vim_item)
    end,
  },
})

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_opts = lsp.build_options("null-ls", {
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", {}),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  sources = {
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.diagnostics.commitlint,
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.prettierd.with({
      filetypes = {
        "astro",
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "markdown",
        "markdown",
        "typescript",
        "typescriptreact",
        "xml",
        "yaml",
      },
    }),
    null_ls.builtins.formatting.stylua,
  },
})

null_ls.setup({
  border = "double",
  on_attach = null_opts.on_attach,
  sources = null_opts.sources,
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})
