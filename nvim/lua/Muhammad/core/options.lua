if Platform.is_not_vscode then
    vim.cmd("let g:netrw_banner = 0")
    vim.opt.nu = true
    vim.opt.rnu = true
    vim.opt.wrap = false
    vim.opt.scrolloff = 8
    vim.opt.termguicolors = true
    vim.opt.background = "dark"
    vim.opt.signcolumn = "yes"
    vim.opt.splitright = true
    vim.opt.splitbelow = true
    vim.opt.backspace = { "start", "eol", "indent" }
    vim.opt.inccommand = "split"
end

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true


vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
vim.g.editorconfig = true


