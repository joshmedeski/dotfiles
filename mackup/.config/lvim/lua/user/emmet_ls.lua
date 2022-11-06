local M = {}

M.config = function()
  local lspconfig = require('lspconfig')
  local configs = require('lspconfig/configs')
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  lspconfig.emmet_ls.setup({
    -- on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
    init_options = {
      html = {
        options = {
          -- NOTE: For possible options, see:
          -- https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          -- ["bem.enabled"] = true,
        },
      },
    }
  })
end

return M
