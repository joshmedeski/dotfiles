return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(plugin)
    local icons = require("icons")

    if plugin.override then
      require("lazyvim.util").deprecate("lualine.override", "lualine.opts")
    end

    -- local hide_in_width = function()
    --   return vim.fn.winwidth(0) > 80
    -- end

    local icons = require("lazyvim.config").icons

    local filetype = { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }
    local filename = { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } }

    local navic = {
      function()
        return require("nvim-navic").get_location()
      end,
      cond = function()
        return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
      end,
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        error = icons.diagnostics.Error,
        hint = icons.diagnostics.Hint,
        info = icons.diagnostics.Info,
        warn = icons.diagnostics.Warn,
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
    }

    local diff = {
      "diff",
      colored = true,
      symbols = {
        added = icons.git.added,
        untracked = icons.git.added,
        modified = icons.git.modified,
        removed = icons.git.removed,
      },
      -- cond = hide_in_width,
    }

    local function fg(name)
      return function()
        ---@type {foreground?:number}?
        local hl = vim.api.nvim_get_hl_by_name(name, true)
        return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
      end
    end

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { diff, diagnostics, filetype, filename, navic },
        lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = fg("Statement")
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Constant") ,
            },
          { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "nvim-tree" },
    }
  end,
}
