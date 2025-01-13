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
}
