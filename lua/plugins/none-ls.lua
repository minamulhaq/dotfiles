return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        cond = not vim.g.vscode,
        config = function()
            local null_ls = require("null-ls")

            -- Configure null-ls with cpplint and clang-format
            null_ls.setup({
                sources = {

                    null_ls.builtins.diagnostics.eslint_d,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.black,
                    -- null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.prettier,
                },

            })

            -- Optional keybindings for linting and formatting
            vim.api.nvim_set_keymap("n", "<leader>gf", ":lua vim.lsp.buf.format({ async = true })<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>d", ":lua vim.diagnostic.open_float()<CR>",
                { noremap = true, silent = true })
        end
    }
}
