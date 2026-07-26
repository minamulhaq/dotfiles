-- after/plugin/snacks.lua

local status, snacks = pcall(require, "snacks")
if not status then
    return
end

-- Initialize modules
snacks.setup({
    bigfile = { enabled = true },
    dashboard = {
        enabled = true,
        preset = {
            -- Define custom keys/sections without invoking lazy.stats
            keys = {
                { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
        },
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
            { section = "projects", icon = " ", title = "Projects", indent = 2, padding = 1 },
            { section = "startup", enabled = false }, -- Explicitly disable lazy.stats metric check
        },
    },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
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
