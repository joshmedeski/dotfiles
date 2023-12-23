return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      { "j-hui/fidget.nvim", opts = {} },

      {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opt = {}
      },

      {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
        keys = {
          { "<leader><space>", "<cmd>CodeActionMenu<cr>", { desc = "Code Action Menu" } },
        },
      },

      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = " ",
              package_pending = "󰌚 ",
              package_uninstalled = "󰢤 ",
            },
          },
        },
      },

      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
        opts = {
          ensure_installed = {
            "astro-language-server",
            "bash-debug-adapter",
            "bash-language-server",
            "cspell",
            "debugpy",
            "delve",
            "docker-compose-language-service",
            "dockerfile-language-server",
            "emmet-language-server",
            "eslint-lsp",
            "gofumpt",
            "goimports",
            "goimports-reviser",
            "gomodifytags",
            "gopls",
            "graphql-language-service-cli",
            "hadolint",
            "impl",
            "js-debug-adapter",
            "json-lsp",
            "lua-language-server",
            "markdownlint",
            "marksman",
            "prettier",
            "prettierd",
            "prisma-language-server",
            "pyright",
            "ruff-lsp",
            "shfmt",
            "stylua",
            "tailwindcss-language-server",
            "typescript-language-server",
            "yaml-language-server",
          },
        },
      },
    },

    config = function()
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(_, bufnr)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        -- See `:help K` for why this keymap
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- nmap("gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
        --   { desc = "Goto Definition", has = "definition" })
        -- nmap("gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })

        -- Lesser used LSP functionality
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end

      for name, icon in pairs(require("config.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end


      -- mason-lspconfig requires that these setup functions are called in this order
      -- before setting up the servers.
      require("mason").setup()
      require("mason-lspconfig").setup()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      --
      --  If you want to override the default filetypes that your language server will attach to you can
      --  define the property 'filetypes' to the map in question.
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },

        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      }

      -- Setup neovim lua configuration
      require("neodev").setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          })
        end,
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
}
