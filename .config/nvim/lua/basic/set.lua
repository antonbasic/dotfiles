vim.opt.number = true
-- vim.opt.relativenumber = true

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true

vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.swapfile = false
vim.o.backup = false

vim.o.clipboard = 'unnamedplus'

vim.o.termguicolors = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

vim.o.hlsearch = true

vim.o.scrolloff = 20

vim.g.calendar_no_mappings = 1
