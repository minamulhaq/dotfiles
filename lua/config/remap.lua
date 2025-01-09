-- Common mappings
vim.keymap.set('v', 'p', 'P', { noremap = true, silent = true }) -- Paste without overwriting register
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- VSCode-specific or standalone mappings
if not vim.g.vscode then
    vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { noremap = true, silent = true }) -- Example: open netrw in standalone Neovim
end

-- Yank into system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { noremap = true, silent = true })
vim.keymap.set("n", "<leader>Y", [["+Y]], { noremap = true, silent = true })

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", [["+p]], { noremap = true, silent = true })

-- Move lines up and down
vim.keymap.set("n", "<leader>j", function()
    vim.cmd("m .+1<CR>==")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>k", function()
    vim.cmd("m .-2<CR>==")
end, { noremap = true, silent = true })

-- Select text after pasting (e.g., for adjusting indentation)
vim.keymap.set("n", "<leader>v", "`[v`]", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format document using LSP" })


-- Load OS-specific remap files
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_macos = vim.loop.os_uname().sysname == "Darwin"

if is_windows then
    local ok, err = pcall(require, "config.remap_win")
    if not ok then
        vim.notify("Failed to load remap_win.lua: " .. err, vim.log.levels.ERROR)
    end
elseif is_macos then
    local ok, err = pcall(require, "config.remap_osx")
    if not ok then
        vim.notify("Failed to load remap_osx.lua: " .. err, vim.log.levels.ERROR)
    end
end