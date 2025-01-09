local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}


keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.config")
require("config.lazy")
