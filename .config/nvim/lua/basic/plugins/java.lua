local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })

return {
  "mfussenegger/nvim-jdtls",
  -- dir = "~/development/neovim-plugins/nvim-jdtls",
  branch = "master",
  ft = { "java", "groovy" },
  dependencies = {
    -- {
    --   -- "616b2f/bsp.nvim"
    --   dir = "/Users/anton/.config/nvim/lplugins/bsp.nvim",
    -- },
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    'rcarriga/nvim-dap-ui',
    'williamboman/mason.nvim',
  },
  init = function()
    require('mason-registry.installer')
  end,
  config = function()
    vim.print()
    local home = os.getenv('HOME')
    local jdtls = require('jdtls')
    -- require("bsp").setup({})

    -- File types that signify a Java project's root directory. This will be
    -- used by eclipse to determine what constitutes a workspace
    local root_markers = { 'gradlew', 'mvnw', '.git' }
    local root_dir = require('jdtls.setup').find_root(root_markers)

    -- eclipse.jdt.ls stores project specific data within a folder. If you are working
    -- with multiple different projects, each project must use a dedicated data directory.
    -- This variable is used to configure eclipse to use the directory name of the
    -- current project found using the root_marker as the folder for project specific data.
    local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    -- Helper function for creating keymaps
    function nnoremap(rhs, lhs, bufopts, desc)
      bufopts.desc = desc
      vim.keymap.set("n", rhs, lhs, bufopts)
    end

    -- The on_attach function is used to set key maps after the language server
    -- attaches to the current buffer
    local on_attach = function(client, bufnr)
      vim.print("attaching")
      vim.bo[bufnr].shiftwidth = 4
      vim.bo[bufnr].tabstop = 4
      vim.bo[bufnr].softtabstop = 4

      -- Regular Neovim LSP client keymappings
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      -- nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
      nnoremap("<leader>ev", jdtls.extract_variable, bufopts, "Extract variable")
      nnoremap("<leader>ec", jdtls.extract_constant, bufopts, "Extract constant")
      vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })

      -- Setup DAP
      require('jdtls').setup_dap({ hotcodereplace = 'auto', })
      -- require('dap.ext.vscode').load_launchjs()

      -- nvim-dap
      nnoremap("<leader>bt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", bufopts, "Set breakpoint")
      nnoremap("<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", bufopts,
        "Set conditional breakpoint")
      nnoremap("<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        bufopts, "Set log point")
      nnoremap('<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>", bufopts, "Clear breakpoints")
      nnoremap('<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', bufopts, "List breakpoints")
      nnoremap("<leader>dc", "<cmd>lua require'dap'.continue()<cr>", bufopts, "Continue")
      nnoremap("<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", bufopts, "Step over")
      nnoremap("<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", bufopts, "Step into")
      nnoremap("<leader>do", "<cmd>lua require'dap'.step_out()<cr>", bufopts, "Step out")
      nnoremap('<leader>dd', "<cmd>lua require'dap'.disconnect()<cr>", bufopts, "Disconnect")
      nnoremap('<leader>dt', "<cmd>lua require'dap'.terminate()<cr>", bufopts, "Terminate")
      nnoremap("<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", bufopts, "Open REPL")
      nnoremap("<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", bufopts, "Run last")
      nnoremap('<leader>di', function() require "dap.ui.widgets".hover() end, bufopts, "Variables")
      nnoremap('<leader>d?', function()
        local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes)
      end, bufopts, "Scopes")
      nnoremap('<leader>df', '<cmd>Telescope dap frames<cr>', bufopts, "List frames")
      nnoremap('<leader>dh', '<cmd>Telescope dap commands<cr>', bufopts, "List commands")

      nnoremap("<leader>vc", jdtls.test_class, bufopts, "Test class (DAP)")
      nnoremap("<leader>vm", jdtls.test_nearest_method, bufopts, "Test method (DAP)")
      print("finished loading lsp and dap")
    end

    local mason_registry = require("mason-registry")
    local jdtls_install_path = mason_registry.get_package("jdtls"):get_install_path()             -- note that this will error if you provide a non-existent package name
    local jdap_install_path = mason_registry.get_package("java-debug-adapter"):get_install_path() -- note that this will error if you provide a non-existent package name

    local bundles = {
      vim.fn.glob(jdap_install_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar')
    }

    local java_test_install_path = mason_registry.get_package('java-test'):get_install_path()

    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_install_path .. '/extension/server/*.jar', 1), "\n"))
    -- vim.list_extend(bundles, {
    --   '/Users/anton/.local/share/nvim/mason/packages/gradle-bsp/server/build/libs/server.jar',
    -- })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


    local config = {
      flags = {
        debounce_text_changes = 80,
      },
      on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map
      capabilities = capabilities,
      root_dir = root_dir,   -- Set the root directory to our found root_marker
      -- Here you can configure eclipse.jdt.ls specific settings
      -- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- for a list of options
      init_options = {
        bundles = bundles,
      },
      settings = {
        java = {
          -- gradle = {
          --   buildServer = "on",
          -- },
          import = {
            gradle = {
              annotationProcessing = {
                enabled = true,
              },
            },
          },
          format = {
            settings = {
              -- Use Google Java style guidelines for formatting
              -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
              -- and place it in the ~/.local/share/eclipse directory
              url = "/.local/share/eclipse/eclipse-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
          -- Specify any completion options
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*"
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*", "sun.*",
            },
          },
          -- Specify any options for organizing imports
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          -- How code generation should act
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          -- If you are developing in projects with different Java versions, you need
          -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- And search for `interface RuntimeOption`
          -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = vim.fn.system("mise where java@temurin-21"):sub(1, -2),
              },
              {
                name = "JavaSE-19",
                path = vim.fn.system("mise where java@temurin-19"):sub(1, -2),
              },
              {
                name = "JavaSE-17",
                path = vim.fn.system("mise where java@temurin-17"):sub(1, -2),
              },
              {
                name = "JavaSE-11",
                path = vim.fn.system("mise where java@temurin-11"):sub(1, -2),
              },
              {
                name = "JavaSE-1.8",
                path = vim.fn.system("mise where java@corretto-8"):sub(1, -2),
              },
            }
          }
        }
      },
      -- cmd is the command that starts the language server. Whatever is placed
      -- here is what is passed to the command line to execute jdtls.
      -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
      -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      -- for the full list of options
      cmd = {
        vim.fn.system("mise where java@temurin-21"):sub(1, -2) .. "/bin/java",
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
        '-javaagent:' .. jdtls_install_path .. '/lombok.jar',

        -- The jar file is located where jdtls was installed. This will need to be updated
        -- to the location where you installed jdtls
        '-jar', vim.fn.glob(jdtls_install_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),

        -- The configuration for jdtls is also placed where jdtls was installed. This will
        -- need to be updated depending on your environment
        '-configuration', jdtls_install_path .. '/config_mac',

        -- Use the workspace_folder defined above to store data for this project
        '-data', workspace_folder,
      },
    }

    -- Finally, start jdtls. This will run the language server using the configuration we specified,
    -- setup the keymappings, and attach the LSP client to the current buffer
    local function jdtls_setup()
      vim.print("JdtlsSetup")
      jdtls.start_or_attach(config)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = java_cmds,
      pattern = { 'java', 'groovy' },
      desc = 'Setup jdtls',
      callback = jdtls_setup,
    })

    -- jdtls_setup()
    --

    local dap = require 'dap'
    local dapui = require 'dapui'
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end
  end
}
