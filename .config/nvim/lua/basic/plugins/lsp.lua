local noop = function() end

return {
  {
    'aznhe21/actions-preview.nvim',
    config = function()
      require('actions-preview').setup({
        telescope = {
          layout_strategy = 'vertical',
        },
        highlight_command = {
          require("actions-preview.highlight").delta('delta --syntax-theme=Nord'),
        },
      })
    end
  },
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      { 'VonHeikemen/lsp-zero.nvim', branch = 'v4.x' },
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
      'aznhe21/actions-preview.nvim',
    },
    config = function()
      require('mason').setup({
        registries = {
          "github:mason-org/mason-registry",
          "file:~/.config/nvim/mason-registry", -- directory of the cloned fork
        }
      })
      local lsp_zero = require('lsp-zero')
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>d,', '<cmd>e .vscode/launch.json<CR>', { desc = 'Edit launch.json' })

      local lsp_attach = function(client, bufnr)
        local setkey = function(keys, func, desc) vim.keymap.set('n', keys, func, { desc = desc, buffer = bufnr }) end
        vim.keymap.set('i', '<Ctrl-Space>', vim.lsp.buf.completion)
        setkey('gd', builtin.lsp_definitions, "LSP Definitions")
        setkey('gi', builtin.lsp_implementations, "LSP Implementations")
        setkey('go', builtin.lsp_type_definitions, "LSP Type Definitions")
        setkey('gr', builtin.lsp_references, "LSP References")
        setkey('K', vim.lsp.buf.hover, "LSP Hover")
        setkey('gD', vim.lsp.buf.declaration, "LSP Declaration")
        setkey('gs', vim.lsp.buf.signature_help, "LSP Signature help")
        setkey('<leader>cr', vim.lsp.buf.rename, "LSP Rename")
        -- setkey('<leader>ca', vim.lsp.buf.code_action, "List code actions")
        setkey('<leader>ca', require('actions-preview').code_actions, "List code actions")
        setkey('<leader>wa', vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        setkey('<leader>wr', vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        setkey('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
          "List workspace folders")
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })

      require('mason-lspconfig').setup({
        ensure_installed = { 'jdtls' },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,

          jdtls = noop,
        }
      })

      local cmp = require('cmp')

      cmp.setup({
        sources = cmp.config.sources(
          { { name = 'nvim_lsp' } },
          { { name = 'mkdnflow' } },
          { { name = 'buffer' } }
        ),
        snippet = {
          expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          -- ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true })
        }),
      })
    end,
  },
}
