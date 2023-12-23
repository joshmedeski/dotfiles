return {
  {
    "folke/which-key.nvim",
    -- displays a popup with possible keybindings of the command you started typing
    opts = {}
  },

  {
    "folke/noice.nvim",
    -- 💥 Highly experimental plugin that completely replaces
    -- the UI for messages, cmdline and the popupmenu.
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    ---@class NoiceConfig
    opts = {
      ---@type NoicePresets
      presets = { inc_rename = true },
      ---@type NoiceConfigViews
      views = {
        cmdline_popup = {
          position = {
            row = 7,
            col = "55%",
          },
        },
        cmdline_popupmenu = {
          position = {
            row = 7,
            col = "55%",
          },
        },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#2E3440",
      stages = "static",
      timeout = 1500,
    },
  },


  {
    "b0o/incline.nvim",
    -- 🎈 Floating statuslines for Neovim
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      debounce_threshold = {
        falling = 50,
        rising = 10
      },
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false
      },
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = "NormalFloat"
          },
          InclineNormalNC = {
            default = true,
            group = "NormalFloat"
          }
        }
      },
      ignore = {
        buftypes = "special",
        filetypes = {},
        floating_wins = true,
        unlisted_buffers = true,
        wintypes = "special"
      },
      window = {
        margin = {
          horizontal = 1,
          vertical = 1
        },
        options = {
          signcolumn = "no",
          wrap = false
        },
        padding = 1,
        padding_char = " ",
        placement = {
          horizontal = "right",
          vertical = "top"
        },
        width = "fit",
        winhighlight = {
          active = {
            EndOfBuffer = "None",
            Normal = "InclineNormal",
            Search = "None"
          },
          inactive = {
            EndOfBuffer = "None",
            Normal = "InclineNormalNC",
            Search = "None"
          }
        },
        zindex = 50
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "bold"
        local function get_diagnostic_label(props)
          local icons = require("config.icons")
          local label = {}
          for severity, icon in pairs(icons.diagnostics) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon .. "" .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          return label
        end

        local function get_git_diff(props)
          local icons = { removed = "", changed = "", added = "" }
          local labels = {}
          local signs = vim.api.nvim_buf_get_var(props.buf, "gitsigns_status_dict")
          for name, icon in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
            end
          end
          return labels
        end

        local buffer = {
          { get_git_diff(props) },
          { get_diagnostic_label(props) },
          {
            ft_icon,
            guifg = ft_color
          },
          { " " },
          {
            filename,
            gui = modified
          },
        }
        return buffer
      end,
    }
  }
}
