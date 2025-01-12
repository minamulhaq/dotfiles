return {
	-- Mason for managing LSP servers, DAP, linters, and formatters
	{
		"williamboman/mason.nvim",
		cond = not vim.g.vscode, -- Only load if NOT in VSCode
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason-LSPConfig for integrating Mason with nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		cond = not vim.g.vscode, -- Only load if NOT in VSCode
		dependencies = { "williamboman/mason.nvim" }, -- Ensure Mason is loaded
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "pyright" },
                automatic_installation = true
			})
		end,
	},

	-- Native LSP configuration
	{
		"neovim/nvim-lspconfig",
        event = {
            "BufReadPre",
            "BufNewFile"
        },
		cond = not vim.g.vscode, -- Only load if NOT in VSCode
		dependencies = { "williamboman/mason-lspconfig.nvim" }, -- Ensure Mason-LSPConfig is loaded
		config = function()
			-- Ensure cmp_nvim_lsp is installed for capabilities
			local status_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if not status_cmp then
				vim.notify("cmp_nvim_lsp not found. Install it for completion capabilities.", vim.log.levels.ERROR)
				return
			end

			local capabilities = cmp_nvim_lsp.default_capabilities()
			local lspconfig = require("lspconfig")

			-- Shared `on_attach` function for all LSP servers
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			-- Lua LSP setup
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Clangd LSP setup
			lspconfig.clangd.setup({
				cmd = { "clangd" },
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Rust LSP setup
			lspconfig.rust_analyzer.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Go LSP setup
			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Python LSP setup (pyright)
			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					python = {
						pythonPath = "/Users/muhammadinamulhaq/.py_envs/3_12/bin/python3.12",
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							autoImportCompletions = true, -- Enable auto-import completions
							useLibraryCodeForTypes = true, -- Use library code for type information
						},
					},
				},
			})
		end,
	},
}
