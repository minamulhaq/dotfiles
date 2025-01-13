return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",

		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",

		-- " For vsnip users.
		-- 'hrsh7th/cmp-vsnip',
		-- 'hrsh7th/vim-vsnip',

		-- " For luasnip users.
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",

		"j-hui/fidget.nvim",

		-- Planery
		"nvim-lua/plenary.nvim",
		-- None-ls
		"nvimtools/none-ls.nvim",
	},

	cond = not vim.g.vscode,
	-- event = "InsertEnter",
	config = function()
		require("fidget").setup({})
		require("mason").setup()
		local mason_lsp_config = require("mason-lspconfig")

		local lspconfig = require("lspconfig")

		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				-- vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
				-- vim.keymap.set('n', '<leader>vd', vim.diagnostics.open_float, opts)
				-- vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
				-- vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.refrences, opts)
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
				vim.keymap.set("n", "<space>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})

		mason_lsp_config.setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"pyright",
				"gopls",
			},
			automatic_installation = true,
			handlers = {

				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["rust_analyzer"] = function()
					lspconfig.rust_analyzer.setup({

						settings = {
							["rust-analyzer"] = {
								capabilities = capabilities,
								diagnostics = {
									enable = true, -- Enable diagnostics
								},
							},
						},
						capabilities = capabilities, -- Pass the capabilities from nvim-cmp
					})
				end,
				["lua_ls"] = function()
					-- local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilitie,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			},
		})

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.scroll_docs(cmp_select),
				["<C-y>"] = cmp.mapping.scroll_docs(cmp_select),
				["<C-Space>"] = cmp.mapping.complete(),

				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})
		vim.diagnostic.config({
			update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- None-ls
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
			},
		})
	end,
}
-- return {
-- 	-- Mason for managing LSP servers, DAP, linters, and formatters
-- 	{
-- 		"williamboman/mason.nvim",
-- 		cond = not vim.g.vscode, -- Only load if NOT in VSCode
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
--
-- 	-- Mason-LSPConfig for integrating Mason with nvim-lspconfig
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		cond = not vim.g.vscode, -- Only load if NOT in VSCode
-- 		dependencies = { "williamboman/mason.nvim" }, -- Ensure Mason is loaded
-- 		config = function()
-- 			require("mason-lspconfig").setup({
-- 				ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "pyright" },
--                 automatic_installation = true
-- 			})
-- 		end,
-- 	},
--
-- 	-- Native LSP configuration
-- 	{
-- 		"neovim/nvim-lspconfig",
--         event = {
--             "BufReadPre",
--             "BufNewFile"
--         },
-- 		cond = not vim.g.vscode, -- Only load if NOT in VSCode
-- 		dependencies = { "williamboman/mason-lspconfig.nvim" }, -- Ensure Mason-LSPConfig is loaded
-- 		config = function()
-- 			-- Ensure cmp_nvim_lsp is installed for capabilities
-- 			local status_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- 			if not status_cmp then
-- 				vim.notify("cmp_nvim_lsp not found. Install it for completion capabilities.", vim.log.levels.ERROR)
-- 				return
-- 			end
--
-- 			local capabilities = cmp_nvim_lsp.default_capabilities()
-- 			local lspconfig = require("lspconfig")
--
-- 			-- Shared `on_attach` function for all LSP servers
-- 			local on_attach = function(client, bufnr)
-- 				local opts = { noremap = true, silent = true, buffer = bufnr }
-- 				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- 				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
-- 				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
-- 				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
-- 				vim.keymap.set("n", "<leader>f", function()
-- 					vim.lsp.buf.format({ async = true })
-- 				end, opts)
-- 			end
--
-- 			-- Lua LSP setup
-- 			lspconfig.lua_ls.setup({
-- 				on_attach = on_attach,
-- 				capabilities = capabilities,
-- 			})
--
-- 			-- Clangd LSP setup
-- 			lspconfig.clangd.setup({
-- 				cmd = { "clangd" },
-- 				on_attach = on_attach,
-- 				capabilities = capabilities,
-- 			})
--
-- 			-- Rust LSP setup
-- 			lspconfig.rust_analyzer.setup({
-- 				on_attach = on_attach,
-- 				capabilities = capabilities,
-- 			})
--
-- 			-- Go LSP setup
-- 			lspconfig.gopls.setup({
-- 				on_attach = on_attach,
-- 				capabilities = capabilities,
-- 			})
--
-- 			-- Python LSP setup (pyright)
-- 			lspconfig.pyright.setup({
-- 				on_attach = on_attach,
-- 				capabilities = capabilities,
-- 				settings = {
-- 					python = {
-- 						pythonPath = "/Users/muhammadinamulhaq/.py_envs/3_12/bin/python3.12",
-- 						analysis = {
-- 							autoSearchPaths = true,
-- 							diagnosticMode = "openFilesOnly",
-- 							autoImportCompletions = true, -- Enable auto-import completions
-- 							useLibraryCodeForTypes = true, -- Use library code for type information
-- 						},
-- 					},
-- 				},
-- 			})
-- 		end,
-- 	},
--
--
--     {
--         'hrsh7th/cmp-nvim-lsp',
--         cond = not vim.g.vscode,
--
--     },
--     {
--         "L3MON4D3/LuaSnip",
--         cond = not vim.g.vscode,
--         dependencies = {
--             "saadparwaiz1/cmp_luasnip",
--             "rafamadriz/friendly-snippets",
--         },
--         config = function()
--             -- Load VSCode-style snippets from friendly-snippets
--             require("luasnip.loaders.from_vscode").lazy_load()
--         end,
--     },
--
--     {
--         "hrsh7th/nvim-cmp",
--         cond = not vim.g.vscode,
--         event = "InsertEnter",
--         dependencies = {
--             "hrsh7th/cmp-nvim-lsp",  -- LSP source
--             "hrsh7th/cmp-buffer",    -- Buffer source
--             "hrsh7th/cmp-path",      -- Path source
--             "hrsh7th/cmp-cmdline",   -- Command-line source
--         },
--         config = function()
--             local cmp = require("cmp")
--             cmp.setup({
--                 snippet = {
--                     -- Use LuaSnip as the snippet engine
--                     expand = function(args)
--                         require("luasnip").lsp_expand(args.body)
--                     end,
--                 },
--                 window = {
--                     completion = cmp.config.window.bordered(),
--                     documentation = cmp.config.window.bordered(),
--                 },
--                 mapping = cmp.mapping.preset.insert({
--                     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--                     ["<C-f>"] = cmp.mapping.scroll_docs(4),
--                     ["<C-Space>"] = cmp.mapping.complete(),
--                     ["<C-e>"] = cmp.mapping.abort(),
--                     ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
--                 }),
--                 sources = cmp.config.sources({
--                     { name = "nvim_lsp" }, -- Enable LSP autocompletion
--                     { name = "luasnip" },  -- Snippet source
--                 }, {
--                     { name = "buffer" },  -- Buffer autocompletion
--                     { name = "path" },    -- File path autocompletion
--                 }),
--             })
--         end,
--     },
--
--
--
-- }
--

-- return {
--     {
--         "jose-elias-alvarez/null-ls.nvim",
--         cond = not vim.g.vscode,
--         config = function()
--             local null_ls = require("null-ls")
--
--             -- Configure null-ls with cpplint and clang-format
--             null_ls.setup({
--                 sources = {
--
--                     null_ls.builtins.diagnostics.eslint_d,
--                     null_ls.builtins.formatting.stylua,
--                     null_ls.builtins.formatting.black,
--                     -- null_ls.builtins.formatting.isort,
--                     null_ls.builtins.formatting.prettier,
--                 },
--
--             })
--
--             -- Optional keybindings for linting and formatting
--             vim.api.nvim_set_keymap("n", "<leader>gf", ":lua vim.lsp.buf.format({ async = true })<CR>",
--                 { noremap = true, silent = true })
--             vim.api.nvim_set_keymap("n", "<leader>d", ":lua vim.diagnostic.open_float()<CR>",
--                 { noremap = true, silent = true })
--         end
--     }
-- }
