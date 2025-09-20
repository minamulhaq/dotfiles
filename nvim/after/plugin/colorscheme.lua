vim.o.background = "dark" -- ensure dark mode
local theme = "gruvbox"
-- local theme = "rose-pine"
if theme == "gruvbox" then
    vim.g.gruvbox_contrast_dark = "hard"
end
vim.cmd.colorscheme(theme)
