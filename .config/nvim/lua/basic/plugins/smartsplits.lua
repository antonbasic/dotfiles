return {
  'mrjones2014/smart-splits.nvim',
  config = function()
    local ss = require('smart-splits')
    vim.keymap.set('n', '<CS-h>', ss.move_cursor_left)
    vim.keymap.set('n', '<CS-j>', ss.move_cursor_down)
    vim.keymap.set('n', '<CS-k>', ss.move_cursor_up)
    vim.keymap.set('n', '<CS-l>', ss.move_cursor_right)
  end
}
