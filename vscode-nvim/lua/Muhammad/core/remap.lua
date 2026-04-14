---@diagnostic disable: undefined-field
local opts = {
    noremap = true,
    silent = true,
}
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.keymap.set("i", "jj", "<Esc>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>y", '"+yy', opts)

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", '"+p', opts)
vim.keymap.set("n", "<leader>P", '"+P', opts)
vim.keymap.set("v", "<leader>p", '"+p', opts)
vim.keymap.set("v", "<leader>P", '"+P', opts)

-- Select blocks after indenting
vim.keymap.set("x", "<", "<gv", { desc = "Reselect visual block after reducing indenting", noremap = true })
vim.keymap.set("x", ">", ">gv|", { desc = "Reselect visual block after increasing indenting", noremap = true })

vim.keymap.set("v", "p", '"_dP', opts)

-- delete without clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- ── VSCode-specific ──────────────────────────────────────────────────────────
local vscode = Platform.vscode_api.api
assert(vscode ~= nil, "VSCode detected but api is nil")

vim.keymap.set("n", "zz", function()
    Platform.vscode_api.MoveCurrentLineToCenter()
end, opts)

vim.keymap.set("n", "<leader>w", function()
    vscode.action("workbench.action.files.save")
end, opts)

vim.keymap.set("n", "*", function()
    vim.cmd(":silent! :norm! *")
    Platform.vscode_api.MoveCurrentLineToCenter()
end, { noremap = true, silent = true })

vim.keymap.set("n", "n", function()
    vim.cmd(":silent! :norm! n")
    Platform.vscode_api.MoveCurrentLineToCenter()
end, { noremap = true, silent = true })

vim.keymap.set("n", "N", function()
    vim.cmd(":silent! :norm! N")
    Platform.vscode_api.MoveCurrentLineToCenter()
end, { noremap = true, silent = true })

--[[
-- IMPORTANT TO PASS KEY THROUGH
    {
        "key": "ctrl+d",
        "command": "vscode-neovim.send",
        "args": "<C-d>",
        "when": "editorTextFocus"
    },
    {
        "key": "ctrl+u",
        "command": "vscode-neovim.send",
        "args": "<C-u>",
        "when": "editorTextFocus"
    }
--]]
vim.keymap.set("n", "<C-d>", function()
    vscode.eval([[
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            await vscode.commands.executeCommand('cursorPageDown');
            await vscode.commands.executeCommand('revealLine', {
                lineNumber: editor.selection.active.line,
                at: 'center'
            });
        }
    ]])
end, opts)

vim.keymap.set("n", "<C-u>", function()
    vscode.eval([[
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            await vscode.commands.executeCommand('cursorPageUp');
            await vscode.commands.executeCommand('revealLine', {
                lineNumber: editor.selection.active.line,
                at: 'center'
            });
        }
    ]])
end, { desc = "Move up and set cursor to centered", noremap = true, silent = true })

vim.keymap.set("v", "J", function()
    vscode.action("editor.action.moveLinesDownAction")
end, opts)

vim.keymap.set("v", "K", function()
    vscode.action("editor.action.moveLinesUpAction")
end, opts)

-- Focus explorer
vim.keymap.set("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
end, opts)

-- IMPORTANT: Add vscode key passthrough for ALT/OPTIONS
local key = Platform.is_macos and "<D-d>" or "<M-d>"
vim.keymap.set({ "n", "x", "i" }, key, Platform.vscode_api.add_selection_to_next)

vim.keymap.set({ "n", "x" }, "<leader>r", function()
    vscode.with_insert(function()
        vscode.action("editor.action.refactor")
    end)
end)

vim.keymap.set("n", "]q", function()
    vscode.action("editor.action.marker.next")
end)

vim.keymap.set("n", "]l", function()
    vscode.action("editor.action.marker.nextInFiles")
end)

vim.keymap.set("n", "[q", function()
    vscode.action("editor.action.marker.prev")
end)

vim.keymap.set("n", "[l", function()
    vscode.action("editor.action.marker.prevInFiles")
end)

vim.keymap.set("n", "<Esc>", function()
    vscode.action("workbench.action.closeQuickOpen")
    vscode.action("workbench.action.closePanel")
    vscode.action("workbench.action.closeSidebar")
end, { noremap = true, silent = true })

-- ── Telescope equivalents ─────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>ff", function()
    vscode.action("workbench.action.quickOpen")
end, opts)

vim.keymap.set("n", "<leader>fg", function()
    vscode.action("workbench.action.findInFiles")
end, opts)

vim.keymap.set("n", "<leader>fb", function()
    vscode.action("workbench.action.showAllEditors")
end, opts)

vim.keymap.set("n", "<leader>fs", function()
    vscode.action("workbench.action.showAllSymbols")
end, opts)

vim.keymap.set({ "n", "v" }, "<leader>fw", function()
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
    vscode.action("workbench.action.findInFiles", {
        args = { query = vim.fn.expand(txt) },
    })
end, { noremap = true, silent = true, desc = "Find in files for word or selection" })


-- Stop output pannel from popping up
vim.o.cmdheight=10


-- ── Trouble equivalents ───────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>tw", function()
    vscode.action("workbench.actions.view.problems")
end, opts)
