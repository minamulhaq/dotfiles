
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

-- Safe background transparency helper
local function set_bg_transparent(group)
    local current = vim.api.nvim_get_hl(0, { name = group, link = false })
    current.bg = "none"
    vim.api.nvim_set_hl(0, group, current)
end

-- 2. Color Handler & Transparency Overrides
function ColorMyPencils(color)
    vim.o.background = "dark"
    color = color or "gruvbox"

    local success = pcall(vim.cmd.colorscheme, color)
    if not success then
        return
    end

    -- Custom Highlight Overrides
    set_bg_transparent("Normal")
    set_bg_transparent("NormalFloat")

    local hl = vim.api.nvim_set_hl
    hl(0, "StatusLine", { bg = "#32302F", fg = "#d4be98" })
    hl(0, "StatusLineNC", { bg = "#32302F", fg = "#7d7d7d" })
    hl(0, "CmdLine", { bg = "#32302F", fg = "#d4be98" })
    hl(0, "MsgArea", { bg = "#32302F", fg = "#d4be98" })

    -- FIX FOR SNACKS.GH:
    -- Provide explicit 'fg' colors for diff groups so snacks.gh doesn't crash on nil fg
    hl(0, "DiffAdd", { fg = "#b8bb26" })
    hl(0, "DiffChange", { fg = "#8ec07c" })
    hl(0, "DiffDelete", { fg = "#fb4934" })
    hl(0, "DiffText", { fg = "#fabd2f" })
    hl(0, "SnacksGhNormalFloat", { fg = "#d4be98" })
end

-- Apply default scheme
ColorMyPencils("gruvbox")
