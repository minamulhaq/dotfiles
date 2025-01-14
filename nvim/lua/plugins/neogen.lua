return {
	"danymat/neogen",
	cond = not vim.g.vscode,
	version = "*",
	dependencies = {
		"L3MON4D3/LuaSnip",
        "nvim-treesitter/nvim-treesitter",
    },
	config = function()
		local neogen = require("neogen")
		neogen.setup({
			snippet_engine = "luasnip",
		})
		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<Leader>nf", function()
			neogen.generate({ type = "func" })
		end, opts)
		vim.keymap.set("n", "<Leader>nt", function()
			neogen.generate({ type = "type" })
		end, opts)
	end,
}
