---@diagnostic disable: undefined-field
local opts = {
    noremap = true,
    silent = true,
}
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.keymap.set("i", "jj", "<Esc>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>y", '"+yy', opts)

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", '"+p', opts)
vim.keymap.set("n", "<leader>P", '"+P', opts)
vim.keymap.set("v", "<leader>p", '"+p', opts)
vim.keymap.set("v", "<leader>P", '"+P', opts)

-- Select blocks after indenting
vim.keymap.set("x", "<", "<gv", { desc = "Reselect visual block after reducing indenting", noremap = true })
vim.keymap.set("x", ">", ">gv|", { desc = "Reselect visual block after increasing indenting", noremap = true })

vim.keymap.set("v", "p", '"_dP', opts)

-- delete without clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>w", ":wa<CR>")
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down and set cursor to centered", noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up and set cursor to centered", noremap = true })

-- move selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, opts)

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
