return {
	{
		"nvim-treesitter/nvim-treesitter",
        cond = not vim.g.vscode,
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				auto_install = true,
				ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "go", "rust" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end

	}
}
