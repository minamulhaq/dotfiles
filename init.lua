local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

keymap("n", "<space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "



require("config.config")
require("config.set")
require("config.lazy")
