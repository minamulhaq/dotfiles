-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.

-- Code Actions / Quick Fix
-- These GLOBAL keymaps are created unconditionally when Nvim starts:
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|

local function neovim_lsp_remap_callback(args)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    --
    -- -- Buffer local mappings.
    -- -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = args.buf }
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

    opts.desc = "Show buffer diagnostics"
    vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

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

local function enable_lsps()
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('clangd')
end




local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_nvim_lsp_ok then
    -- Merge default capabilities with cmp
    vim.lsp.protocol.make_client_capabilities = (function(orig)
        return function()
            return vim.tbl_deep_extend(
                "force",
                orig(),
                cmp_nvim_lsp.default_capabilities()
            )
        end
    end)(vim.lsp.protocol.make_client_capabilities)
end

enable_lsps()
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        neovim_lsp_remap_callback(args)
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

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
    -- virtual_lines = {
    --     -- Only show virtual line diagnostics for the current cursor line
    --     current_line = true,
    -- },

})
