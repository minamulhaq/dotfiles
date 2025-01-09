local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

print("macos confs loading")
vim.keymap.set('n', '<D-w>', ':q<CR>', {
    noremap = true,
    silent = true,
    desc = "Close Neovim split (macOS)"
})

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
