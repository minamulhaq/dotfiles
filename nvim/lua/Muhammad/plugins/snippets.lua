return {
	"L3MON4D3/LuaSnip",
    cond = Platform.is_not_vscode,
	dependencies = {
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")

		vim.keymap.set({ "i" }, "<C-K>", function()
			ls.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-L>", function()
			ls.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-J>", function()
			ls.jump(-1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			if ls.choice_active() then
				ls.change_choice(1)
		end
		end, { silent = true })

		-- require("luasnip.loaders.from_vscode").lazy_load()

		-- friendly-snippets - enable standardized comments snippets
		require("luasnip").filetype_extend("typescript", { "tsdoc" })
		require("luasnip").filetype_extend("javascript", { "jsdoc" })
		require("luasnip").filetype_extend("lua", { "luadoc" })
		require("luasnip").filetype_extend("python", { "pydoc" })
		require("luasnip").filetype_extend("rust", { "rustdoc" })
		require("luasnip").filetype_extend("cs", { "csharpdoc" })
		-- require("luasnip").filetype_extend("java", { "javadoc" })
		require("luasnip").filetype_extend("c", { "cdoc" })
		require("luasnip").filetype_extend("cpp", { "cppdoc" })
		-- require("luasnip").filetype_extend("php", { "phpdoc" })
		-- require("luasnip").filetype_extend("kotlin", { "kdoc" })
		-- require("luasnip").filetype_extend("ruby", { "rdoc" })
		-- require("luasnip").filetype_extend("sh", { "shelldoc" })
	end,
}
