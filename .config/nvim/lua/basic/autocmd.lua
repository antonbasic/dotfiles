-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "set awa" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NeogitCommitMessage",
  callback = function()
    local ls = require('luasnip')
    local snippet = ls.get_snippets()["NeogitCommitMessage"][1]
    ls.snip_expand(snippet)
  end
})

vim.filetype.add({
  pattern = {
    ['jdt://*'] = "java",
  },
})
