return {
    {
        'hrsh7th/cmp-nvim-lsp',
        cond = not vim.g.vscode,

    },
    {
        "L3MON4D3/LuaSnip",
        cond = not vim.g.vscode,
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            -- Load VSCode-style snippets from friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        cond = not vim.g.vscode,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",  -- LSP source
            "hrsh7th/cmp-buffer",    -- Buffer source
            "hrsh7th/cmp-path",      -- Path source
            "hrsh7th/cmp-cmdline",   -- Command-line source
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    -- Use LuaSnip as the snippet engine
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- Enable LSP autocompletion
                    { name = "luasnip" },  -- Snippet source
                }, {
                    { name = "buffer" },  -- Buffer autocompletion
                    { name = "path" },    -- File path autocompletion
                }),
            })
        end,
    },
}

