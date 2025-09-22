local function neovim_lsp_remap_callback(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    --
    -- -- Buffer local mappings.
    -- -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    opts.desc = "List workspace folder"
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    opts.desc = "Add Workspace Folder"
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    opts.desc = "Remove Workspace Folder"
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

    opts.desc = "Workspace Symbol"
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)

    opts.desc = "Go to declaration"
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "Show LSP definitions"
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)


    opts.desc = "Show LSP references"
    vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "Show LSP implementations"
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP type definitions"
    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "See available code actions"
    vim.keymap.set({ "n", "v" }, "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)

    opts.desc = "Smart rename"
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "Show buffer diagnostics"
    vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Show documentation for what is under cursor"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Restart LSP"
    vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)

    opts.desc = "Buffer format"
    vim.keymap.set("n", "<leader>fd", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end

local function vscode_lsp_remap_callback(ev)
    -- Code Actions / Quick Fix
    -- These GLOBAL keymaps are created unconditionally when Nvim starts:
    -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
    -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
    -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
    -- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
    -- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
    -- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
    -- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
    local vscode = Platform.vscode_api
    vscode.notify("Setting up vscode lsp remaps")

    vim.keymap.set({ "n", "x" }, "gra", function()
        vscode.action("editor.action.quickFix")
    end, {
        desc = "[VSCode] Open editor actions",
        noremap = true,
    })

    -- Buf Rename
    vim.keymap.set("n", "grn", function()
        vscode.action("editor.action.rename")
    end, { desc = "[VSCode] Rename symbol", noremap = true })

    vim.keymap.set("n", "grr", function()
        vscode.action("references-view.findReferences")
    end, { desc = "[VSCode] Find references", noremap = true })

    vim.keymap.set("n", "gri", function()
        vscode.action("editor.action.goToImplementation")
    end, { desc = "[VSCode] Go to implementation", noremap = true })


    vim.keymap.set("n", "grt", function()
        vscode.action("editor.action.goToTypeDefinition")
    end, { desc = "[VSCode] Go to type definition", noremap = true })

    vim.keymap.set("n", "gO", function()
        vscode.action("workbench.action.gotoSymbol")
    end, { desc = "[VSCode] Document symbols", noremap = true })

    vim.keymap.set("i", "<C-s>", function()
        vscode.action("editor.action.triggerParameterHints")
    end, { desc = "[VSCode] Signature help", noremap = true })



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
end

return {
    "neovim/nvim-lspconfig",
    cond = Platform.is_not_vscode,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "folke/lazydev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        -- { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        if Platform.is_vscode then
            vscode_lsp_remap_callback()
        else
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = neovim_lsp_remap_callback
            })
        end

        -- Define sign icons for each severity
        local signs = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
        }

        -- Diagnostics
        vim.diagnostic.config({
            signs = {
                text = signs
            },
            virtual_text = true,
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                -- source = "always",
                source = true,
                header = "",
                prefix = "",
            },
        })












        -- Setup servers
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_nvim_lsp.default_capabilities()
        )

        -- Global LSP settings (applied to all servers)
        vim.lsp.config('*', {
            capabilities = capabilities,
        })

        -- Configure and enable LSP servers
        -- lua_ls
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
        vim.lsp.enable("lua_ls")

        -- gopls
        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })
        vim.lsp.enable("gopls")

        vim.lsp.config("ruff", {
            capabilities = capabilities,
            settings = {},
        })
        vim.lsp.enable("ruff")


        vim.lsp.config("clangd", {
            settings = {},
            capabilities = capabilities,
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
            cmd = {
                "clangd",
            },
        })
        vim.lsp.enable("clangd")
    end,
}
