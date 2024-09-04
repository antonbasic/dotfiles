return { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        require('which-key').setup()
        -- Document existing key chains
        require('which-key').add({
            { "<leader>q", group = "[Q]uit" },
            { "<leader>c", group = "[C]ode" },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>g", group = "[G]it" },
            { "<leader>s", group = "[S]earch" },
            { "<leader>f", group = "[F]ind" },
            { "<leader>w", group = "[W]orkspace" },
        })
    end,
}

