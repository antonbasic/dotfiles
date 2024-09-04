return {
  {
    "NeogitOrg/neogit",
    dir = "~/development/neovim-plugins/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local ng = require("neogit")

      ng.setup( {
        git_services = {
          ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
          ["gitlab.leanon.se"] = "https://gitlab.leanon.se/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        },
      })

      vim.keymap.set("n", "<leader>gg", ng.open, { desc = "Launch Neogit" })
      vim.keymap.set("n", "<leader>gl", function() ng.open({ "log" }) end, { desc = "Git log" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require('gitsigns')

      gitsigns.setup({})

      vim.keymap.set("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })
      vim.keymap.set('n', '<leader>gb', gitsigns.blame, { desc = "Blame file" })
    end,
  },
}

  -- {
  --   "tpope/vim-fugitive",
  --   lazy = false,
  --   keys = {
    --     { "<leader>gg", "<cmd>Git<CR>", desc = "Git status" },
    --     { "<leader>gb", "<cmd>Git blame<CR>", desc = "Toggle git blame" },
    --     { "<leader>gl", "<cmd>Git log --date=short --pretty=format:'%C(auto)%h %cd %<(10,trunc)%an %s' -- %<CR>", desc = "File commit history" },
    --     -- How to track specific lines https://github.com/tpope/vim-fugitive/discussions/1862
    --   },
    -- },

    -- {
      --   "kdheepak/lazygit.nvim",
      --   -- optional for floating window border decoration
      --   dependencies = {
        --     "nvim-lua/plenary.nvim",
        --   },
        --   keys = {
          --     { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
          --   },
          -- },
