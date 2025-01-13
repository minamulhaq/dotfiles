local opts = {
	noremap = true,
	silent = true,
}
vim.g.clipboard = vim.g.vscode_clipboard
vim.opt.scrolloff = 8
vim.o.hlsearch = false -- Highlight search results
vim.o.incsearch = true -- Enable incremental search
vim.o.termguicolors = true -- Enable true colors
vim.o.cmdheight = 1
vim.opt.background = "dark"

vim.keymap.set("n", "x", '"_x', opts)

if vim.g.vscode then
	vim.notify = require("vscode").notify
	vim.g.clipboard = vim.g.vscode_clipboard
else
	vim.o.number = true -- Show line numbers
	vim.o.relativenumber = true -- Show relative numbers
	vim.o.tabstop = 4 -- Set tab width to 4 spaces
	vim.o.shiftwidth = 4 -- Set indentation to 4 spaces
	vim.o.expandtab = true -- Use spaces instead of tabs
	vim.o.wrap = false -- Disable line wrapping
	vim.opt.smartindent = true
	vim.opt.swapfile = false
	vim.opt.backup = false

	-- transparent background
	-- Enable true colors
	vim.opt.termguicolors = true

	-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
	vim.opt.undofile = true

	vim.opt.hlsearch = false
	vim.opt.incsearch = true

	vim.opt.termguicolors = true

	vim.opt.scrolloff = 8
	vim.opt.signcolumn = "yes"
	vim.opt.isfname:append("@-@")

	vim.opt.updatetime = 50

	-- vim.opt.colorcolumn = "80"
	-- Install nvim-reload via your plugin manager

end
