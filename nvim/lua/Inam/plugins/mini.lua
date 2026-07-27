-- after/plugin/mini.lua

-- Pairs
require("mini.pairs").setup()

-- Completion
require("mini.completion").setup()

-- Comment
require("mini.comment").setup({
    mappings = {
        comment = "gc",
        comment_line = "gcc",
        textobject = "gc",
    },
})

-- Surround
require("mini.surround").setup({
    custom_surroundings = nil,
    highlight_duration = 300,
    mappings = {
        add = "sa",
        delete = "ds",
        find = "sf",
        find_left = "sF",
        highlight = "msh",
        replace = "sr",
        update_n_lines = "sn",
        suffix_last = "l",
        suffix_next = "n",
    },
    n_lines = 50,
    respect_selection_type = false,
    search_method = "cover",
    silent = false,
})
