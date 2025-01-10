local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}
vim.g.clipboard = vim.g.vscode_clipboard
vim.opt.scrolloff = 8
vim.o.hlsearch = false -- Highlight search results
vim.o.incsearch = true -- Enable incremental search
vim.o.termguicolors = true -- Enable true colors
vim.o.cmdheight = 1
vim.opt.guifont = "MesloLGS NF:h11" -- h11 sets the font size to 11

vim.keymap.set('n', 'x', '"_x', opts)

if vim.g.vscode then
    vim.notify = require("vscode").notify
    vim.g.clipboard = vim.g.vscode_clipboard
else
    vim.o.guifont = 'Meslo Nerd Font'
    vim.o.number = true -- Show line numbers
    vim.o.relativenumber = true -- Show relative numbers
    vim.o.tabstop = 4 -- Set tab width to 4 spaces
    vim.o.shiftwidth = 4 -- Set indentation to 4 spaces
    vim.o.expandtab = true -- Use spaces instead of tabs
    vim.o.wrap = false -- Disable line wrapping
    vim.opt.smartindent = true
    vim.opt.swapfile = false
    vim.opt.backup = false
end
