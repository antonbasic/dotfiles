-- TODO
--
-- Maybe don't use telekasten?
--
-- Requirements
-- - Work with other markdown plugins
-- - Work with marksman lsp?
-- - Follow links
-- - Get beautiful links
-- - Easy open todays note, create if not exist
-- - Easy search of all notes
-- - Easy create new note with template

return {
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = {
  --     "markdown",
  --     "telekasten",
  --   },
  --   config = function()
  --
  --     require('render-markdown').setup({
  --       file_types = { 'markdown', 'telekasten' },
  --       link = {
  --         enabled = true,
  --       },
  --     })
  --   end,
  -- },
  {
    -- 'nvim-telekasten/telekasten.nvim',
    dir = "~/development/neovim-plugins/telekasten.nvim",
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-telekasten/calendar-vim',
    },
    config = function()
      local telekasten = require('telekasten')
      local home = vim.fn.expand("~/Documents/notes")

      telekasten.setup({
        home = home,
        dailies = 'daily',
        weeklies = 'weekly',
        templates = 'templates',
        image_subdir = 'images',
        filename_space_subst = '-',
        uuid_type = "%Y-%m-%d",
        new_note_filename = 'uuid-title',
        journal_auto_open = true,
        -- template_new_note = home .. "/" .. "templates/new_note.md",
        template_new_daily = home .. "/templates/daily.md",
        template_new_weekly = home .. "/templates/weekly.md",
        command_palette_theme = 'dropdown',
        show_tags_theme = 'dropdown',
        new_note_location = 'prefer_home',
        media_previewer = 'viu-previewer',
      })

      -- Launch panel if nothing is typed after <leader>z
      vim.keymap.set("n", "<leader>zp", telekasten.panel, { desc = "Command panel" })

      -- Most used functions
      vim.keymap.set("n", "<leader>zf", telekasten.find_notes, { desc = "Find notes" })
      vim.keymap.set("n", "<leader>zg", telekasten.search_notes, { desc = "Search notes" })
      vim.keymap.set("n", "<leader>zd", telekasten.goto_today, { desc = "Goto today" })
      vim.keymap.set("n", "<leader>zz", telekasten.follow_link, { desc = "Follow link" })
      vim.keymap.set("n", "<leader>zy", telekasten.yank_notelink, { desc = "Yank note link" })
      vim.keymap.set("n", "<leader>zn", telekasten.new_note, { desc = "New note" })
      vim.keymap.set("n", "<leader>zt", telekasten.new_templated_note, { desc = "New note" })
      vim.keymap.set("n", "<leader>zc", telekasten.show_calendar, { desc = "Show calendar" })
      vim.keymap.set("n", "<leader>zb", telekasten.show_backlinks, { desc = "Show backlinks" })
      vim.keymap.set("n", "<leader>zI", telekasten.insert_img_link, { desc = "Insert img link" })
      vim.keymap.set("n", "<leader>zj", telekasten.goto_active_ticket, { desc = "Goto active jira" })

      -- Call insert link automatically when we start typing a link
      vim.keymap.set("i", "[[", telekasten.insert_link, { desc = "Insert link" })
    end,
  }
}
