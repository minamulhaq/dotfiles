-- after/plugin/trouble.lua

local devicons_status, devicons = pcall(require, "nvim-web-devicons")
if devicons_status then
    devicons.setup()
end

local todo_status, todo = pcall(require, "todo-comments")
if todo_status then
    todo.setup()
end

local status, trouble = pcall(require, "trouble")
if not status then
    return
end

-- Pass your options
trouble.setup({
    focus = true,
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>tw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace Diagnostics" })
map("n", "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Document Diagnostics" })
map("n", "<leader>tq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List" })
map("n", "<leader>tl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location List" })
map("n", "<leader>tt", "<cmd>Trouble todo toggle<CR>", { desc = "TODOs" })
