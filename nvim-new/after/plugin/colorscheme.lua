-- /Users/muhammadinamulhaq/.config/nvim-new/after/plugin/colorscheme.lua

local ok, gruvbox = pcall(require, "gruvbox")
if not ok then
    return
end

-- 1. Plugin Configuration
gruvbox.setup({
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
    inverse = true,
    contrast = "hard",
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = true,
})

-- 2. Color Handler & Transparency Overrides
function ColorMyPencils(color)
    vim.o.background = "dark"
    color = color or "gruvbox"
    
    local success = pcall(vim.cmd.colorscheme, color)
    if not success then
        return
    end

    -- Custom Highlight Overrides
    local hl = vim.api.nvim_set_hl
    hl(0, "Normal", { bg = "none" })
    hl(0, "NormalFloat", { bg = "none" })
    hl(0, "StatusLine", { bg = "#32302F", fg = "#d4be98" })
    hl(0, "StatusLineNC", { bg = "#32302F", fg = "#7d7d7d" })
    hl(0, "CmdLine", { bg = "#32302F", fg = "#d4be98" })
    hl(0, "MsgArea", { bg = "#32302F", fg = "#d4be98" })
end

-- Apply default scheme
ColorMyPencils("gruvbox")
