--  TODO: DIAGNOSTICS ARE MISSING
local vscode = nil
if vim.g.vscode then
	vscode = require("vscode")
end
local opts = {
	noremap = true,
	silent = true,
}

local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_macos = vim.loop.os_uname().sysname == "Darwin"

return {
	setup = function()
		-- Highlight on yank
		vim.api.nvim_create_autocmd("TextYankPost", {
			group = vim.api.nvim_create_augroup("HighlightYank", {}),
			callback = function()
				vim.highlight.on_yank({
					higroup = "IncSearch",
					timeout = 50, -- Duration in milliseconds
					on_visual = true, -- Also highlight visually-selected text
				})
			end,
		})

		vim.keymap.set("v", "p", '"_dP', opts)

		-- Yank to system clipboard
		vim.keymap.set("v", "<leader>y", '"+y', {
			noremap = true,
			silent = true,
			desc = "Yank selection to clipboard",
		})
		vim.keymap.set("n", "<leader>Y", '"+yg_', {
			noremap = true,
			silent = true,
			desc = "Yank line to clipboard excluding newline",
		})
		vim.keymap.set("n", "<leader>y", '"+y', {
			noremap = true,
			silent = true,
			desc = "Yank to clipboard",
		})

		-- Paste from system clipboard
		vim.keymap.set("n", "<leader>p", '"+p', {
			noremap = true,
			silent = true,
			desc = "Paste after cursor from clipboard",
		})
		vim.keymap.set("n", "<leader>P", '"+P', {
			noremap = true,
			silent = true,
			desc = "Paste before cursor from clipboard",
		})
		vim.keymap.set("v", "<leader>p", '"+p', {
			noremap = true,
			silent = true,
			desc = "Paste after selection from clipboard",
		})
		vim.keymap.set("v", "<leader>P", '"+P', {
			noremap = true,
			silent = true,
			desc = "Paste before selection from clipboard",
		})

		vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
			desc = "Move selection down",
			noremap = true,
		})
		vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
			desc = "Move selection up",
			noremap = true,
		})

		-- Select blocks after indenting
		vim.keymap.set("x", "<", "<gv", {
			desc = "Reselect visual block after reducing indenting",
			noremap = true,
		})
		vim.keymap.set("x", ">", ">gv|", {
			desc = "Reselect visual block after increasing indenting",
			noremap = true,
		})

		vim.keymap.set("n", "<C-d>", "<C-d>zz", {
			desc = "Move cursor to middle",
			noremap = true,
		})
		vim.keymap.set("n", "<C-u>", "<C-u>zz", {
			desc = "Move cursor to middle",
			noremap = true,
		})

		-- save the file
		vim.keymap.set("n", "<leader>w", ":w<CR>", opts)

		-- Code Actions (Quickfix)
		if is_macos then
			vim.keymap.set({ "n", "x" }, "<D>.", function()
				vscode.action("editor.action.quickFix")
			end, {
				desc = "[VSCode] Open editor actions",
				noremap = true,
			})
		elseif is_windows then
			vim.keymap.set({ "n", "x" }, "<A>.", function()
				vscode.action("editor.action.quickFix")
			end, {
				desc = "[VSCode] Open editor actions",
				noremap = true,
			})
		end

		if vim.g.vscode then
			-- Implement for vscode
			-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Move cursor to middle', noremap = true })
			-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Move cursor to middle', noremap = true })

			-- Use VSCode's vertical split action
			vim.keymap.set("n", "<leader>vv", function()
				require("vscode").action("workbench.action.splitEditor")
			end, {
				noremap = true,
				silent = true,
				desc = "[VSCode] Vertical split",
			})

			vim.keymap.set("n", "<leader>vh", function()
				require("vscode").action("workbench.action.splitEditorOrthogonal")
			end, {
				noremap = true,
				silent = true,
				desc = "[VSCode] Horizontal split",
			})

			vim.keymap.set("n", "<leader>h", "<cmd>lua require('vscode').action('workbench.action.navigateLeft')<CR>")
			vim.keymap.set("n", "<leader>l", "<cmd>lua require('vscode').action('workbench.action.navigateRight')<CR>")

			vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
			vim.keymap.set(
				{ "n", "v" },
				"<leader>sp",
				"<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>"
			)
			vim.keymap.set(
				{ "n", "v" },
				"<leader>fd",
				"<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>"
			)

			-- Hightlight on yank
			-- Highlight yanked text
			vim.api.nvim_create_augroup("highlight_yank", {})
			vim.api.nvim_create_autocmd("TextYankPost", {
				group = "highlight_yank",
				callback = function()
					vim.highlight.on_yank({
						higroup = "IncSearch",
						timeout = 100,
					})
				end,
			})

			-- Explorer

			-- code navigation
			vim.keymap.set(
				{ "n", "v" },
				"gr",
				"<cmd>lua require('vscode').action('references-view.findReferences')<CR>"
			)

			vim.keymap.set({ "n", "v" }, "?", function()
				local txt = ""
				if vim.fn.mode() == "v" then
					local selection = vscode.eval("return vscode.window.activeTextEditor.selection")
					if selection and not selection.isEmpty then
						txt = vscode.eval(
							"return vscode.window.activeTextEditor.document.getText(vscode.window.activeTextEditor.selection)"
						)
					end
				else
					txt = vim.fn.expand("<cword>")
				end
				require("vscode").action("workbench.action.findInFiles", {
					args = {
						query = vim.fn.expand(txt),
					},
				})
			end, {
				noremap = true,
				silent = true,
				desc = "Find in files for word or selection",
			})

			if is_macos then
			elseif is_windows then
			end

			-- Move cursor to position on screen

			local zzvscode = function()
				vscode.action("revealLine", {
					args = {
						at = "center",
						lineNumber = vim.api.nvim_win_get_cursor(0)[1],
					},
				})
			end

			vim.keymap.set("n", "n", function()
				vim.cmd("normal! n")
				zzvscode()
			end, opts)

			vim.keymap.set("n", "N", function()
				vim.cmd("normal! N")
				zzvscode()
			end, opts)
		else
			vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, opts) -- Example: open netrw in standalone Neovim
			vim.keymap.set("n", "n", "nzzzv", opts)
			vim.keymap.set("n", "N", "Nzzzv", opts)
			vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
			vim.keymap.set("n", "<C-u>", "<C-u>zz", {
				desc = "Move cursor to middle",
				noremap = true,
			})

			-- NeoTree toggle
			vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", opts)

			-- from PRIME
			--
			vim.keymap.set("n", "Q", "<nop>")
			vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
			-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

			-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
			-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
			-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
			-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
			--
			-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
			-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
			--
			-- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
			-- vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");
			--
			-- vim.keymap.set("n", "<leader><leader>", function()
			--     vim.cmd("so")
			-- end)
		end
	end,
}

-- harpoon keymaps
-- keymap({"n", "v"}, "<leader>ha", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")
-- keymap({"n", "v"}, "<leader>ho", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>")
-- keymap({"n", "v"}, "<leader>he", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>")
-- keymap({"n", "v"}, "<leader>h1", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>")
-- keymap({"n", "v"}, "<leader>h2", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>")
-- keymap({"n", "v"}, "<leader>h3", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>")
-- keymap({"n", "v"}, "<leader>h4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>")
-- keymap({"n", "v"}, "<leader>h5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>")
-- keymap({"n", "v"}, "<leader>h6", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor6')<CR>")
-- keymap({"n", "v"}, "<leader>h7", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor7')<CR>")
-- keymap({"n", "v"}, "<leader>h8", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor8')<CR>")
-- keymap({"n", "v"}, "<leader>h9", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor9')<CR>")
