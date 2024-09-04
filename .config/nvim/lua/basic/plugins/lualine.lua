return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'linrongbin16/lsp-progress.nvim',
      opts = true,
    },
  },
  config = function()
    require('lualine').setup({
      theme = 'nord',
      sections = {
        lualine_c = {
          'filename',
          function()
            -- invoke `progress` here.
            return require('lsp-progress').progress()
          end,
        },
      },
    })

    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end
}
