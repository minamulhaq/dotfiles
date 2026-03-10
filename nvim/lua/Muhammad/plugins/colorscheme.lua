return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "hard",
                palette_overrides = {},
                overrides = {
                    Normal = { bg = "none" },
                    NormalFloat = { bg = "none" },
                },
                dim_inactive = false,
                transparent_mode = true,
            })
        end,
        opts = {},
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            -- vim.cmd("colorscheme rose-pine")
        end,
    },
}
