return {
    'nvim-lualine/lualine.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local filename = {
            'filename',
            file_status = true,
            path = 0
        }
        local custom_gruvbox = require 'lualine.themes.gruvbox'
        -- Set your custom colors for the statusline
        custom_gruvbox.normal.c.bg = "#32302F"
        custom_gruvbox.normal.c.fg = "#d4be98"
        custom_gruvbox.inactive.c.bg = "#32302F"
        custom_gruvbox.inactive.c.fg = "#7d7d7d"
        -- Optionally, set for other modes (insert, visual, etc.) if you want them to match:
        custom_gruvbox.insert.c.bg = "#32302F"
        custom_gruvbox.insert.c.fg = "#d4be98"
        custom_gruvbox.visual.c.bg = "#32302F"
        custom_gruvbox.visual.c.fg = "#d4be98"
        custom_gruvbox.replace.c.bg = "#32302F"
        custom_gruvbox.replace.c.fg = "#d4be98"
        custom_gruvbox.command.c.bg = "#32302F"
        custom_gruvbox.command.c.fg = "#d4be98"

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = custom_gruvbox,
                component_separators = {
                    left = '',
                    right = ''
                },
                section_separators = {
                    left = '',
                    right = ''
                },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {}
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics', 'nvim_diagnostics', 'nvim_lsp' },
                lualine_c = { filename },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        }
    end
}
