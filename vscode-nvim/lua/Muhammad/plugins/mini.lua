return {
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        version = "*",
        config = function()
            require("mini.pairs").setup()
        end,
    },
    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.comment").setup({
                mappings = {
                    comment = "gc",
                    comment_line = "gcc",
                    textobject = "gc",
                },
            })
        end,
    },
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {
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
        },
    },
}
