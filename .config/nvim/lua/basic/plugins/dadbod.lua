return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',     lazy = true },
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      lazy = true,
    },
    { 'pbogut/vim-dadbod-ssh' },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  config = function()
    -- require("vim-dadbod-ui").setup {}
    --
    require('cmp').setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
    -- require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
    vim.keymap.set('n', 'gr', "<Plug>(DBUI_JumpToForeignKey)")
  end,
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
