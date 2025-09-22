-- Code Actions / Quick Fix
-- These GLOBAL keymaps are created unconditionally when Nvim starts:
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
local vscode = assert(Platform.vscode_api.api)
-- vscode.notify("Setting up vscode lsp remaps")

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
        ---@diagnostic disable-next-line: undefined-field
        local selection = vscode.eval("return vscode.window.activeTextEditor.selection")
        if selection and not selection.isEmpty then
            ---@diagnostic disable-next-line: undefined-field
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

-- editor.action.triggerParameterHints

vim.keymap.set("i", "<C-h>", function()
    vscode.action("editor.action.triggerParameterHints")
end)

-- Format document
vim.keymap.set({ "n", "v" }, "<leader>fd", function()
    vscode.action("editor.action.formatDocument")
end)
