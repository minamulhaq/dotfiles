-- after/plugin/snacks.lua

local status, snacks = pcall(require, "snacks")
if not status then
    return
end

-- Initialize modules
snacks.setup({
    bigfile = { enabled = true },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
        enabled = true,
        matcher = {
            smartcase = false, -- always case-insensitive; mixed-case queries (e.g. "SafetRun100px") still match lowercase/uppercase targets like "...PxRos.cpp"
        },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
})

-- Common Picker Keymaps
local map = vim.keymap.set

-- Files & Search
map("n", "<leader>ff", function() snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>fg", function() snacks.picker.grep() end, { desc = "Live Grep" })
map("n", "<leader>fb", function() snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() snacks.picker.help() end, { desc = "Help Tags" })
map("n", "<leader>fe", function() snacks.explorer() end, { desc = "File Explorer" })

-- LSP Navigation
map("n", "gd", function() snacks.picker.lsp_definitions() end, { desc = "LSP Definition" })
map("n", "gr", function() snacks.picker.lsp_references() end, { desc = "LSP References" })
map("n", "gi", function() snacks.picker.lsp_implementations() end, { desc = "LSP Implementation" })
-- Via Snacks Lua API
vim.keymap.set("n", "<leader>ci", function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = "LSP: Incoming Calls" })

vim.keymap.set("n", "<leader>co", function()
  Snacks.picker.lsp_outgoing_calls()
end, { desc = "LSP: Outgoing Calls" })
