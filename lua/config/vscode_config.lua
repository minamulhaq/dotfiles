if vim.g.vscode then
    local vscode = require('vscode')
    vim.notify = vscode.notify
    vim.keymap.set({"n", "x"}, "<leader>gf", function()
        vscode.with_insert(function()
            vscode.action("editor.action.formatDocument")
        end)
    end, {
        noremap = true,
        silent = true,
        desc = "Format document using VSCode action"
    })
end

