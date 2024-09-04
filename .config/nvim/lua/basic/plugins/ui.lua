return {
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({
        transparent = true,
      })
      vim.cmd.colorscheme("nord")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "frappe",
  --       integration_default = false,
  --       integrations = {
  --         -- barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
  --         cmp = true,
  --         gitsigns = true,
  --         -- hop = true,
  --         -- illuminate = { enabled = true },
  --         native_lsp = { enabled = true, inlay_hints = { background = true } },
  --         -- neogit = true,
  --         neotree = true,
  --         -- semantic_tokens = true,
  --         treesitter = true,
  --         treesitter_context = true,
  --         vimwiki = true,
  --         overseer = true,
  --         which_key = true,
  --         -- aerial = true,
  --         -- fidget = true,
  --         mason = true,
  --         -- neotest = true,
  --         dap_ui = true,
  --         telescope = {
  --             enabled = true,
  --             -- style = "nvchad",
  --         },
  --       },
  --     })
  --     vim.cmd.colorscheme "catppuccin"
  --   end,
  -- },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local noice = require('noice')

      noice.setup({
        lsp = {
          progress = {
            enabled = false,
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
      })

      require("telescope").load_extension("noice")
    end,
  },
  {
    'rcarriga/nvim-notify',
    dependencies = 'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    config = function()
      vim.notify = require("notify")
      require("telescope").load_extension("notify")
    end,
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = {
      -- char = '┊',
      -- show_trailing_blankline_indent = false,
    },
  },
}
