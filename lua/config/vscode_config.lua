local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}
local vscode = require('vscode')

vim.notify = vscode.notify
vim.g.clipboard = vim.g.vscode_clipboard

if vim.g.vscode then
    require("lua.config.osx.config_osx")
else
end
