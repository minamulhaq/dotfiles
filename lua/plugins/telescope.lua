return {
	{
		"nvim-telescope/telescope.nvim",
		cond = not vim.g.vscode,
		tag = "0.1.8",
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>kmaps", builtin.keymaps, { desc = "Telescope help tags" })






		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		cond = not vim.g.vscode,
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
