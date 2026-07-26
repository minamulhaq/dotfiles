-- after/plugin/fugitive.lua

local map = vim.keymap.set

-- Global Git Mappings (Isolated under <leader>g*)
map("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git Commit" })
map("n", "<leader>gv", "<cmd>Gdiffsplit<CR>", { desc = "Git Diff Vertical Split" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git Blame" })
map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git Log" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git Push" })
map("n", "<leader>gP", "<cmd>Git pull --rebase<CR>", { desc = "Git Pull Rebase" })

-- Buffer-Local Mappings inside Fugitive Window (:Git)
local myFugitive = vim.api.nvim_create_augroup("myFugitive", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = myFugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()

        local function buf_map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, remap = false, desc = desc })
        end

        buf_map("<leader>P", function() vim.cmd.Git("push") end, "Git Push")
        buf_map("<leader>p", function() vim.cmd.Git({ "pull", "--rebase" }) end, "Git Pull Rebase")
        buf_map("<leader>t", ":Git push -u origin ", "Git Push Tracking Branch")
    end,
})
