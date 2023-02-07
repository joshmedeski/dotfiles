return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    { "zbirenbaum/copilot-cmp" },
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "copilot" } }))
    opts.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, item)
        local icons = require("lazyvim.config").icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind]
        end
        return item
      end,
    }
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "NONE", bg = "#000000" })
    vim.cmd([[highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch]])
    vim.cmd([[highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080]])
    vim.cmd([[highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6]])
    vim.cmd([[highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch]])
    vim.cmd([[highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE]])
    vim.cmd([[highlight! link CmpItemKindInterface CmpItemKindVariable]])
    vim.cmd([[highlight! link CmpItemKindText CmpItemKindVariable]])
    vim.cmd([[highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0]])
    vim.cmd([[highlight! link CmpItemKindMethod CmpItemKindFunction]])
    vim.cmd([[highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4]])
    vim.cmd([[highlight! link CmpItemKindProperty CmpItemKindKeyword]])
    vim.cmd([[highlight! link CmpItemKindUnit CmpItemKindKeyword]])
    -- original LazyVim kind icon formatter
    local format_kinds = opts.formatting.format
    opts.formatting.format = function(entry, item)
      format_kinds(entry, item) -- add icons
      return require("tailwindcss-colorizer-cmp").formatter(entry, item)
    end
  end,
}
