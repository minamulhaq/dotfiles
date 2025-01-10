local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

keymap("v", "J", ":m '>+1<CR>gv=gv") -- Move selection down
keymap("v", "K", ":m '<-2<CR>gv=gv") -- Move selection up

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

if vim.g.vscode then
    -- VSCode-specific mappings for n and N with centering
    vim.keymap.set("n", "n", function()
        vim.cmd("normal! nzz") -- Move to next search result
    end, opts)
    vim.keymap.set("n", "N", function()
        vim.cmd("normal! N") -- Move to previous search result
    end, opts)
else
    vim.keymap.set("n", "n", "nzzzv", opts)
    vim.keymap.set("n", "N", "Nzzzv", opts)
end



keymap({ "n", "v" }, "<leader>p", '"+p', opts)
keymap("x", "<leader>p", "\"_d", opts) -- Replace without overwriting clipboard
keymap({'n', 'v'}, "<leader>y", "\"+y", opts)
-- keymap({'n','v'}, 'p', 'P', opts) -- Paste without overwriting register
-- keymap('n', '<leader>w', ':w<CR>', opts)
-- keymap('n', '<Esc>', ':nohlsearch<CR>', opts)

-- -- Yank into system clipboard
-- keymap({"n", "v"}, "<leader>y", [["+y]], opts)
-- keymap("n", "<leader>Y", [["+Y]], opts)

-- -- Paste from system clipboard
-- keymap("n", "<leader>p", [["+p]], opts)

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

-- Load OS-specific remap files
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_macos = vim.loop.os_uname().sysname == "Darwin"

if is_macos then
    print("macos confs loading")
    vim.keymap.set('n', '<D-w>', ':q<CR>', opts)
elseif is_windows then
    vim.keymap.set('n', '<C-w>', ':q<CR>', opts)
end

if vim.g.vscode then
    -- call vscode commands from neovim
    -- general keymaps

    -- harpoon keymaps
    -- keymap({"n", "v"}, "<leader>ha", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")
    -- keymap({"n", "v"}, "<leader>ho", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>")
    -- keymap({"n", "v"}, "<leader>he", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>")
    -- keymap({"n", "v"}, "<leader>h1", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>")
    -- keymap({"n", "v"}, "<leader>h2", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>")
    -- keymap({"n", "v"}, "<leader>h3", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>")
    -- keymap({"n", "v"}, "<leader>h4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>")
    -- keymap({"n", "v"}, "<leader>h5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>")
    -- keymap({"n", "v"}, "<leader>h6", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor6')<CR>")
    -- keymap({"n", "v"}, "<leader>h7", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor7')<CR>")
    -- keymap({"n", "v"}, "<leader>h8", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor8')<CR>")
    -- keymap({"n", "v"}, "<leader>h9", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor9')<CR>")

    -- splits and naivagation
    keymap({"n", "v"}, "<leader>v", "<cmd>lua require('vscode').action('workbench.action.splitEditorRight')<CR>")
    keymap("n", "<leader>h", "<cmd>lua require('vscode').action('workbench.action.navigateLeft')<CR>")
    keymap("n", "<leader>l", "<cmd>lua require('vscode').action('workbench.action.navigateRight')<CR>")

    keymap({"n", "v"}, "<leader>b", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")
    keymap({"n", "v"}, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
    keymap({"n", "v"}, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>")
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
end
