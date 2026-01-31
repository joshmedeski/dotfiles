return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
  cmds = { 'LspCopilotSignIn' },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- dap
    'mfussenegger/nvim-dap',
    { 'jay-babu/mason-nvim-dap.nvim' },

    -- Faster LuaLS setup for Neovim
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          { 'nvim-dap-ui' },
        },
      },
    },

    -- Useful status updates for LSP.
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0,
            align = 'top',
          },
        },
      },
    },

    -- autocomplete
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('jam-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Jump to the declaration of the word under your cursor.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Incremental rename
        -- map('<leader>rN', require('inc_rename').rename(vim.fn.expand '<cword>'), 'Incremental LSP renaming', { 'n' })

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local lspIcons = require('utils.icons').lsp
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = { text = { ERROR = '', WARN = '', INFO = '', HINT = '' } },
      -- virtal_text = true,
      virtual_text = {
        -- TODO: setup neovim plugin that allows the value to be toggled based on the comment line above it (or LSP value?)
        -- 'eol', 'inline', 'overlay', 'right_align'
        virt_text_pos = 'eol',
        prefix = '',
        format = function(diagnostic)
          local icons = {
            [vim.diagnostic.severity.ERROR] = lspIcons.error,
            [vim.diagnostic.severity.WARN] = lspIcons.warn,
            [vim.diagnostic.severity.INFO] = lspIcons.info,
            [vim.diagnostic.severity.HINT] = lspIcons.hint,
          }
          return string.format('%s %s', icons[diagnostic.severity], diagnostic.message)
        end,
      },
    }

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      copilot = {},

      gopls = {},

      eslint = {
        settings = { workingDirectories = { mode = 'auto' } },
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
      },

      ts_ls = {
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
      },
      tailwindcss = {
        filetypes = {
          'astro',
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
      },

      graphql = {
        filetypes = {
          'graphql',
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
      },

      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },

      jsonls = {},

      arduino_language_server = {
        filetypes = {
          'arduino',
          'cpp',
          'c',
          'ino',
        },
      },

      astro = {
        filetypes = {
          'javascript',
          'typescript',
          'json',
          'jsonc',
          'javascriptreact',
          'typescriptreact',
          'astro',
          'svelte',
          'vue',
          'css',
        },
        root_dir = require('lspconfig.util').root_pattern 'astro.config.mjs',
      },

      biome = {
        filetypes = {
          'javascript',
          'typescript',
          'json',
          'jsonc',
          'javascriptreact',
          'typescriptreact',
          'astro',
          'svelte',
          'vue',
          'css',
        },
        root_dir = require('lspconfig.util').root_pattern 'biome.json',
      },

      openscad_lsp = {
        filetypes = { 'openscad' },
      },

      vue_ls = {
        filetypes = { 'vue' },
      },

      gdtoolkit = {
        filetypes = { 'gdscript' },
      },

      actionlint = {
        filetypes = { 'yaml' },
      },

      shellcheck = {
        filetypes = { 'sh', 'bash' },
      },

      docker_compose_language_service = {
        filetypes = {
          'yaml',
        },
      },

      cucumber_language_server = {
        filetypes = {
          'cucumber',
        },
      },

      cssls = {
        filetypes = { 'css' },
      },

      svelte = {
        filetypes = { 'svelte' },
      },

      black = {
        filetypes = { 'python' },
      },

      -- css_variables = {
      --   filetypes = { 'css' },
      -- },
    }

    ---@type MasonLspconfigSettings
    ---@diagnostic disable-next-line: missing-fields
    require('mason-lspconfig').setup {
      automatic_enable = vim.tbl_keys(servers or {}),
    }

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    --
    -- `mason` had to be setup earlier: to configure its options see the
    -- `dependencies` table for `nvim-lspconfig` above.
    --
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'typescript-language-server',
      'js-debug-adapter',
      'gopls',
      'delve',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Installed LSPs are configured and enabled automatically with mason-lspconfig
    -- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
    end

    -- if vim.lsp.inline_completion then
    --   vim.lsp.inline_completion.enable()
    -- end
    --
    -- vim.keymap.set('i', '<Tab>', function()
    --   if not vim.lsp.inline_completion.get() then
    --     return '<Tab>'
    --   end
    -- end, { expr = true, desc = 'Accept the current inline completion' })

    require('mason-nvim-dap').setup()
  end,
}
