return {
  'oribarilan/lensline.nvim',
  tag = '1.1.0',
  event = 'LspAttach',
  keys = {
    { '<leader>L', '<cmd>LenslineToggle<cr>', desc = 'Toggle Lensline' },
  },
  config = function()
    require('lensline').setup {
      style = {
        separator = ' ', -- separator between all lens attributes
        -- highlight = 'Comment', -- highlight group for lens text
        prefix = '', -- prefix before lens content
        placement = 'inline', -- "above" | "inline" - where to render lenses (consider prefix = "" for inline)
      },

      providers = {
        {
          name = 'function_length_range',
          enabled = true,
          event = { 'BufWritePost', 'TextChanged' },
          handler = function(bufnr, func_info, _, callback)
            local utils = require 'lensline.utils'
            local function_lines = utils.get_function_lines(bufnr, func_info)
            local start_line = func_info.line
            local end_line = start_line + #function_lines - 1
            local total_lines = end_line - start_line
            callback {
              line = func_info.line,
              text = string.format('%d:%d (%d)', start_line, end_line, total_lines),
            }
          end,
        },

        -- { name = 'references', enabled = true },
        {
          name = 'references_with_warning',
          enabled = true,
          event = { 'LspAttach', 'BufWritePost' },
          handler = function(bufnr, func_info, _, callback)
            local utils = require 'lensline.utils'

            utils.get_lsp_references(bufnr, func_info, function(references)
              if references then
                local count = #references
                local icon, text

                if count == 0 then
                  icon = utils.if_nerdfont_else('⚠️ ', 'WARN ')
                  text = icon .. 'No references'
                else
                  icon = utils.if_nerdfont_else('󰌹 ', '')
                  local suffix = utils.if_nerdfont_else('', ' refs')
                  text = icon .. count .. suffix
                end

                callback { line = func_info.line, text = text }
              else
                callback(nil)
              end
            end)
          end,
        },

        { name = 'complexity', enabled = true },
      },
    }
  end,
}
