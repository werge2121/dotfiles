-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- add gruvbox
    --{ "ellisonleao/gruvbox.nvim" },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            style = "night"
        },
    },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight",
        },
    },
    { "christoomey/vim-tmux-navigator" },
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('harpoon').setup({
                menu = {
                    width = math.floor(vim.api.nvim_win_get_width(0) * 0.8)
                }
            })

            vim.keymap.set('n', '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",
                { desc = "Go to harpoon 1" })
            vim.keymap.set('n', '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",
                { desc = "Go to harpoon 2" })
            vim.keymap.set('n', '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",
                { desc = "Go to harpoon 3" })
            vim.keymap.set('n', '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",
                { desc = "Go to harpoon 4" })
            vim.keymap.set('n', '<leader>5', "<cmd>lua require('harpoon.ui').nav_file(5)<CR>",
                { desc = "Go to harpoon 5" })
            vim.keymap.set('n', '<leader>6', "<cmd>lua require('harpoon.ui').nav_file(6)<CR>",
                { desc = "Go to harpoon 6" })
            vim.keymap.set('n', '<leader>7', "<cmd>lua require('harpoon.ui').nav_file(7)<CR>",
                { desc = "Go to harpoon 7" })
            vim.keymap.set('n', '<leader>8', "<cmd>lua require('harpoon.ui').nav_file(8)<CR>",
                { desc = "Go to harpoon 8" })
            vim.keymap.set('n', '<leader>9', "<cmd>lua require('harpoon.ui').nav_file(9)<CR>",
                { desc = "Go to harpoon 9" })
            vim.keymap.set('n', '<leader>ha', "<cmd>lua require('harpoon.mark').add_file()<CR>",
                { desc = "Add file to harpoon" })
            vim.keymap.set('n', '<leader>hh', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
                { desc = "Open harpoon menu" })
        end
    },
    {
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require "octo".setup()
        end
    },
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            return {}
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- this way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = { eslint = {} },
            setup = {
                eslint = function()
                    require("lazyvim.util").on_attach(function(client)
                        if client.name == "eslint" then
                            client.server_capabilities.documentFormattingProvider = true
                        elseif client.name == "tsserver" then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end)
                end,
            },
        },
    },
    {
        "echasnovski/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
                { opts.mappings.delete,         desc = "Delete surrounding" },
                { opts.mappings.find,           desc = "Find right surrounding" },
                { opts.mappings.find_left,      desc = "Find left surrounding" },
                { opts.mappings.highlight,      desc = "Highlight surrounding" },
                { opts.mappings.replace,        desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gza",            -- Add surrounding in Normal and Visual modes
                delete = "gzd",         -- Delete surrounding
                find = "gzf",           -- Find surrounding (to the right)
                find_left = "gzF",      -- Find surrounding (to the left)
                highlight = "gzh",      -- Highlight surrounding
                update_n_lines = "gzn", -- Update `n_lines`
                replace = "gzr",        -- Replace surrounding
            },
        },
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo
                        .commentstring
                end,
            },
        },
    }
}
