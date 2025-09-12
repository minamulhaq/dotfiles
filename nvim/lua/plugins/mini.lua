return {
	{
		"echasnovski/mini.surround",
		version = "*", -- Use '*' for the latest stable release
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = "*", -- Use '*' for the latest stable release
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.bracketed",
		version = "*", -- Use '*' for the latest stable release
		config = function()
			require("mini.bracketed").setup()
		end,
	},

	{
		"echasnovski/mini.completion",
		version = "*", -- Use '*' for the latest stable release
		config = function()
			require("mini.completion").setup()
		end,
	},

	{
		"echasnovski/mini.comment",
		version = "*", -- Use '*' for the latest stable release
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
}
