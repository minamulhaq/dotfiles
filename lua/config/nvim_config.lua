local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}
-- Common mappings
keymap('v', 'p', 'P', opts) -- Paste without overwriting register
keymap('n', '<leader>w', ':w<CR>', opts)
keymap('n', '<Esc>', ':nohlsearch<CR>', opts)

-- Yank into system clipboard
keymap({"n", "v"}, "<leader>y", [["+y]], opts)
keymap("n", "<leader>Y", [["+Y]], opts)

-- Paste from system clipboard
keymap("n", "<leader>p", [["+p]], opts)

keymap('x', '<', '<gv', {
    desc = 'Reselect visual block after reducing indenting',
    noremap = true
})
keymap('x', '>', '>gv|', {
    desc = 'Reselect visual block after increasing indenting',
    noremap = true
})

-- smart up and down
vim.keymap.set('n', '<down>', 'gj', {
    desc = 'Move down in wrapped lines',
    silent = true,
    remap = true
})
vim.keymap.set('n', '<up>', 'gk', {
    desc = 'Move up in wrapped lines',
    silent = true,
    remap = true
})

if vim.g.vscode then
    -- splits and naivagation
    keymap({"n", "v"}, "<leader>v", "<cmd>lua require('vscode').action('workbench.action.splitEditorRight')<CR>")
    keymap("n", "<leader>h", "<cmd>lua require('vscode').action('workbench.action.navigateLeft')<CR>")
    keymap("n", "<leader>l", "<cmd>lua require('vscode').action('workbench.action.navigateRight')<CR>")

    keymap({"n", "v"}, "<leader>b", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")
    keymap({"n", "v"}, "<leader>d", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>")
    keymap({"n", "v"}, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
    keymap({"n", "v"}, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>")
    keymap({"n", "v"}, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>")
    keymap({"n", "v"}, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>")
    keymap({"n", "v"}, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")

    -- Hightlight on yank
    -- Highlight yanked text
    vim.api.nvim_create_augroup("highlight_yank", {})
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = "highlight_yank",
        callback = function()
            vim.highlight.on_yank({
                higroup = "IncSearch",
                timeout = 100
            })
        end
    })

    -- code navigation
    keymap({"n", "v"}, "gr", "<cmd>lua require('vscode').action('references-view.findReferences')<CR>")

else
    vim.o.number = true -- Show line numbers
    vim.o.relativenumber = true -- Show relative numbers
    vim.o.tabstop = 4 -- Set tab width to 4 spaces
    vim.o.shiftwidth = 4 -- Set indentation to 4 spaces
    vim.o.expandtab = true -- Use spaces instead of tabs
    vim.o.wrap = false -- Disable line wrapping
    vim.o.hlsearch = true -- Highlight search results
    vim.o.incsearch = true -- Enable incremental search
    vim.o.termguicolors = true -- Enable true colors
    vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, opts) -- Example: open netrw in standalone Neovim
end
