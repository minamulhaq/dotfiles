if Platform.is_not_vscode then
    local theme = "gruvbox"
    -- Default options:
    require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
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
        inverse = true,    -- invert background for search, diffs, statuslines and errors
        contrast = "hard", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
    })
    vim.cmd("colorscheme gruvbox")



    function ColorMyPencils(color)
        vim.o.background = "dark"
        color = color or "gruvbox"
        vim.cmd.colorscheme(color)
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

        -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#32302F", fg = "#d4be98" })
        -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#32302F", fg = "#7d7d7d" })
        -- -- Add command line highlights to match tmux
        -- vim.api.nvim_set_hl(0, "CmdLine", { bg = "#32302F", fg = "#d4be98" })
        -- vim.api.nvim_set_hl(0, "MsgArea", { bg = "#32302F", fg = "#d4be98" })
    end

    ColorMyPencils(theme)
end
