return {
  'nvim-telescope/telescope.nvim',
  version = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-media-files.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          "^.git/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    });
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ss', builtin.current_buffer_fuzzy_find, { desc = '[S]earch current buffer' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search [f]iles' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Rip[g]rep search' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Search git commits' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Search open [b]uffers' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search [h]elp tags' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = 'Search [m]arks' })

    require("nvim-web-devicons").setup({
      color_icons = true,
      default = true,
    })

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    telescope.load_extension('media_files')
  end,
}
