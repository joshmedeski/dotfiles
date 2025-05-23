--[[

lOOOOOO.
  0,,,,;O,'.
  O,,,,ld,,,,dlllllllllllllllllllc.
 .xlllld:,,,lx,,,,,,,,,,,,,,,,,,dl''.
    ......,,xc,,,,,,,,,,,,,,,,,,O,'''.
     ;;;;;;:0,,,,;Olcccccckc,,,,0''''
    .O::::::;,,,,oo'......O;,,,cx''''
    lo,,,,,,,,,,,k;'''...'0,,,,dc''''
    k;,,,,,,,,,,,klllllllod,,,,0''''.
    0,,,,,,,,,,,,,,,,,,,,,,,,,;O''''
   ,k,,,,,,,,,,,,,,,,,,,,,,,,,cd''''
   oo,,,,,,,,,,,kllllllllk,,,,x:''''
   O;,,,,,,,,,,,0'......:x,,,,0''''.
  .0,,,,,,,,,,,cx'''.   xc,,,;O''''
  ;k,,,,,,,,,,,dc''''   0,,,,lo''''.
  ;ollllllllllld''''.   dllllo,'''''..
    ...............'      .......'''''
                            .......'''
                              .......'

Use your Neovim like using Cursor AI IDE!
--]]

return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  enabled = true,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    'ravitemer/mcphub.nvim',
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = true,
          prompt_for_file_name = true,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = false,
        },
      },
    },
  },

  config = function()
    require('avante').setup {
      windows = {
        postion = 'right',
        width = 40,
        sidebar_header = {
          enabled = true,
          align = 'left',
          rounded = true,
        },
        input = {
          prefix = ' ',
          height = 12, -- Height of the input window in vertical layout
        },
      },

      file_selector = {
        provider = 'telescope',
      },
      selector = {
        provider = 'telescope',
      },

      -- cursor_applying_provider = nil,
      behaviour = {
        enable_cursor_planning_mode = true,
        enable_claude_text_editor_tool_mode = true,
      },

      provider = 'copilot',
      copilot = {
        model = 'claude-3.7-sonnet',
      },
      ollama = {
        model = 'qwen2.5-coder:7b',
      },

      -- TODO: research what value this provides and setup correctly
      -- rag_service = {
      --   enabled = true, -- Enables the RAG service
      --   host_mount = os.getenv 'HOME' .. '/github',
      --   provider = 'ollama',
      --   llm_model = 'deepseek-r1:8b',
      --   endpoint = 'http://localhost:11434',
      -- },

      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub:get_active_servers_prompt()
      end,

      custom_tools = function()
        return {
          require('mcphub.extensions.avante').mcp_tool(),
        }
      end,

      -- If you are using the builtin Neovim server, you might have to disable the following tools in your avante config to avoid any conflicts.
      -- disabled_tools = {
      --   'list_files',
      --   'search_files',
      --   'read_file',
      --   'create_file',
      --   'rename_file',
      --   'delete_file',
      --   'create_dir',
      --   'rename_dir',
      --   'delete_dir',
      --   'bash',
      -- },
    }
  end,
}
