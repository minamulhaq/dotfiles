local M = {}
if Platform.is_not_vscode then
    M = {
        "folke/trouble.nvim",
        cond = Platform.is_not_vscode,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "folke/todo-comments.nvim",
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>tw",
                "<cmd>Trouble diagnostics toggle<CR>",
                desc = "Workspace Diagnostics",
            },
            {
                "<leader>td",
                "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
                desc = "Document Diagnostics",
            },
            {
                "<leader>tq",
                "<cmd>Trouble qflist toggle<CR>",
                desc = "Quickfix List",
            },
            {
                "<leader>tl",
                "<cmd>Trouble loclist toggle<CR>",
                desc = "Location List",
            },
            {
                "<leader>tt",
                "<cmd>Trouble todo toggle<CR>",
                desc = "TODOs",
            },
        },
        opts = {
            focus = true,
        },
    }
else
    local vscode = assert(Platform.vscode_api.api)
    vim.keymap.set("n", "<leader>tw", function()
        vscode.action("workbench.actions.view.problems")
    end)
end
return M
