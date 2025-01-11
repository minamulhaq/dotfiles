return {
    "ellisonleao/gruvbox.nvim",
    cond = not vim.g.vscode,
    priority = 1000,
    config = function()
        -- Configure gruvbox with custom options
        require("gruvbox").setup({
            terminal_colors = true, -- Enable terminal colors
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
            inverse = true, -- Invert background for search, diffs, statuslines, and errors
            contrast = "hard", -- Options: "hard", "soft", or empty string
            palette_overrides = {},
            overrides = {
                Normal = { bg = "none" }, -- Transparent background for normal mode
                NormalFloat = { bg = "none" }, -- Transparent background for floating windows
            },
            dim_inactive = false,
            transparent_mode = true, -- Enable transparency
        })

        vim.cmd([[colorscheme gruvbox]])
    end,
   opts = {},
}
