return {
    {
        "tpope/vim-fugitive",
        cond = not vim.g.vscode,
        config = function()
            vim.keymap.set("n", "<leader>gg", vim.cmd.Git)

            local myFugitive = vim.api.nvim_create_augroup("myFugitive", {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = myFugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = { buffer = bufnr, remap = false }

                    vim.keymap.set("n", "<leader>P", function()
                        vim.cmd.Git("push")
                    end, opts)

                    -- NOTE: rebase always
                    vim.keymap.set("n", "<leader>p", function()
                        vim.cmd.Git({ "pull", "--rebase" })
                    end, opts)

                    -- NOTE: easy set up branch that wasn't setup properly
                    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
                end,
            })
        end,
    },
}
