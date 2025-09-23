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
vim.keymap.set("v", "<leader>y", '"+y', opts)  -- yank selection
vim.keymap.set("n", "<leader>y", '"+yy', opts) -- yank current line

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", '"+p', opts) -- paste after cursor
vim.keymap.set("n", "<leader>P", '"+P', opts) -- paste before cursor
vim.keymap.set("v", "<leader>p", '"+p', opts) -- replace selection
vim.keymap.set("v", "<leader>P", '"+P', opts) -- replace before    -- save the file



-- Select blocks after indenting
vim.keymap.set("x", "<", "<gv", {
    desc = "Reselect visual block after reducing indenting",
    noremap = true,
})
vim.keymap.set("x", ">", ">gv|", {
    desc = "Reselect visual block after increasing indenting",
    noremap = true,
})

vim.keymap.set("v", "p", '"_dP', opts)

-- delete without clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

if Platform.is_not_vscode then
    vim.keymap.set("n", "<leader><leader>", function()
        vim.cmd("so")
    end)
    vim.keymap.set("n", "<leader>w", ":wa<CR>")
    vim.keymap.set("n", "n", "nzzzv", opts)
    vim.keymap.set("n", "N", "Nzzzv", opts)
    vim.keymap.set("n", "<C-d>", "<C-d>zz", {
        desc = "Move down and set cursor to centered",
        noremap = true,
    })
    vim.keymap.set("n", "<C-u>", "<C-u>zz", {
        desc = "Move up and set cursor to centered",
        noremap = true,
    })

    -- move selection up and down
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

    -- TODO: Apply for vscode
    -- ------------------------------------------------------

    -- ------------------------------------------------------

    -- Example: open netrw in standalone Neovim
    vim.keymap.set("n", "<leader>e", vim.cmd.Ex, opts)

    vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
    vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
    vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
    vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

    vim.keymap.set("n", "Q", "<nop>")
    vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

    vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
else
    local vscode = Platform.vscode_api.api
    assert(vscode ~= nil, "Vscode detected but api is nil")
    -- vscode.notify("Setting up vscode LSP")

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
    end, {
        desc = "Move up and set cursor to centered",
        noremap = true,
        silent = true
    })


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

    vim.keymap.set({ "n", "v" }, "<leader>td", function()
        vscode.action("workbench.actions.view.problems")
    end, opts)

    -- IMPORTANT: Add vscode key passthrough for ALT/OPTIONS
    local key = Platform.is_macos and "<D-d>" or "<M-d>"
    vim.keymap.set({ "n", "x", "i" }, key, Platform.vscode_api.add_selection_to_next)

    vim.keymap.set({ "n", "x" }, "<leader>r", function()
        vscode.with_insert(function()
            vscode.action("editor.action.refactor")
        end)
    end)

    vim.keymap.set("n", "<C-k>", function()
        vscode.action("editor.action.marker.next")
    end)

    vim.keymap.set("n", "<C-j>", function()
        vscode.action("editor.action.marker.prev")
    end)


    vim.keymap.set("n", "<leader>k", function()
        vscode.action("editor.action.marker.next")
    end)

    vim.keymap.set("n", "<leader>j", function()
        vscode.action("editor.action.marker.prev")
    end)


    -- [[
    -- ESC KEYS : TODO what to close
    -- {
    --     "key": "escape",
    --     "command": "vscode-neovim.send",
    --     "when": "true",
    --     "args": "<escape>"
    -- }
    -- ]]
    vim.keymap.set("n", "<Esc>", function()
        vscode.action("workbench.action.closePanel")
        vscode.action("workbench.action.closeSidebar")
    end)
end
