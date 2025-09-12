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

		-- " For luasnip users.
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",

		"j-hui/fidget.nvim",

		-- Planery
		"nvim-lua/plenary.nvim",
		-- None-ls
		"nvimtools/none-ls.nvim",
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",

		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},

	cond = not vim.g.vscode,
	-- event = "InsertEnter",
	config = function()
		require("mason-null-ls").setup({
			ensure_installed = {
				-- "ruff",
				"prettier",
				"shfmt",
			},
		})
		require("mason").setup({})
		require("fidget").setup({})
		local luasnip = require("luasnip")

		local mason_lsp_config = require("mason-lspconfig")

		local lspconfig = require("lspconfig")

		local cmp = require("cmp")

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
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
				vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
				vim.keymap.set("n", "<leader>fd", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = ev.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = ev.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		mason_lsp_config.setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
			},
			automatic_installation = true,
			handlers = {

				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["pyright"] = function()
					lspconfig.pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									ignore = { "*" }, -- ignore in favor of ruff
									-- autoSearchPaths = true,
									-- diagnosticMode = "openFilesOnly",
									-- useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,

				["ruff"] = function()
					require("lspconfig").ruff.setup({
						capabilities = capabilities,
						settings = {},
					})
				end,

				["clangd"] = function()
					print("Attaching clangd")
					lspconfig.clangd.setup({
						settings = {},
						capabilities = capabilities,
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
						cmd = {
							"clangd",
						},
					})
				end,

				["rust_analyzer"] = function()
					lspconfig.rust_analyzer.setup({
						cmd = { "rust-analyzer" },
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
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["gopls"] = function()
					-- local lspconfig = require("lspconfig")
					lspconfig.gopls.setup({
						capabilities = capabilities,
						settings = {},
						cmd = { "gopls" },
					})
				end,
			},
		})

		-- local kind_icons = {
		-- 	Text = "󰉿",
		-- 	Method = "m",
		-- 	Function = "󰊕",
		-- 	Constructor = "",
		-- 	Field = "",
		-- 	Variable = "󰆧",
		-- 	Class = "󰌗",
		-- 	Interface = "",
		-- 	Module = "",
		-- 	Property = "",
		-- 	Unit = "",
		-- 	Value = "󰎠",
		-- 	Enum = "",
		-- 	Keyword = "󰌋",
		-- 	Snippet = "",
		-- 	Color = "󰏘",
		-- 	File = "󰈙",
		-- 	Reference = "",
		-- 	Folder = "󰉋",
		-- 	EnumMember = "",
		-- 	Constant = "󰇽",
		-- 	Struct = "",
		-- 	Event = "",
		-- 	Operator = "󰆕",
		-- 	TypeParameter = "󰊄",
		-- }

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			-- window = {
			--     completion = cmp.config.window.bordered(),
			--     documentation = cmp.config.window.bordered(),
			-- },
			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(), -- Select the [n]ext item
				["<C-k>"] = cmp.mapping.select_prev_item(), -- Select the [p]revious item
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept the completion with Enter.
				["<C-Space>"] = cmp.mapping.complete({}), -- Manually trigger a completion from nvim-cmp.
				["<C-c>"] = cmp.mapping({
					i = cmp.mapping.complete(),
					c = cmp.mapping.complete(),
				}),
				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),

				-- Select next/previous item with Tab / Shift + Tab
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
			-- formatting = {
			-- 	fields = { "kind", "abbr", "menu" },
			-- 	format = function(entry, vim_item)
			-- 		-- Kind icons
			-- 		-- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- 		-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			-- 		vim_item.menu = ({
			-- 			nvim_lsp = "[LSP]",
			-- 			luasnip = "[Snippet]",
			-- 			buffer = "[Buffer]",
			-- 			path = "[Path]",
			-- 		})[entry.source.name]
			-- 		return vim_item
			-- 	end,
			-- },
		})

		-- cmp.setup({
		-- 	snippet = {
		-- 		-- REQUIRED - you must specify a snippet engine
		-- 		expand = function(args)
		-- 			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		-- 		end,
		-- 	},
		-- 	window = {
		-- 		-- completion = cmp.config.window.bordered(),
		-- 		-- documentation = cmp.config.window.bordered(),
		-- 	},
		-- 	mapping = cmp.mapping.preset.insert({
		-- 		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		-- 		["<C-n>"] = cmp.mapping.scroll_docs(cmp_select),
		-- 		["<C-y>"] = cmp.mapping.scroll_docs(cmp_select),
		-- 		["<C-Space>"] = cmp.mapping.complete(),
		-- 		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		-- 		["<C-f>"] = cmp.mapping.scroll_docs(4),
		-- 		["<C-e>"] = cmp.mapping.abort(),
		-- 		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		-- 	}),
		-- 	sources = cmp.config.sources({
		-- 		{ name = "nvim_lsp" },
		-- 		{ name = "luasnip" }, -- For luasnip users.
		-- 	}, {
		-- 		{ name = "buffer" },
		-- 	}),
		-- })
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

		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier", -- ts/js formatter
				"stylua", -- lua formatter
				"eslint_d", -- ts/js linter
				"shfmt",
				-- "ruff",
			},
			automatic_installation = true,
		})
		local sources = {
			null_ls.builtins.formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.shfmt.with({ args = { "-i", "4" } }),
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
		}
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			-- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			-- formats doc on save
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
