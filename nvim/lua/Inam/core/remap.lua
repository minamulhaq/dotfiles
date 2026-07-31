---@diagnostic disable: undefined-field
local opts = {
    noremap = true,
    silent = true,
}
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("i", "jj", "<Esc>")

-- restart
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>")

-- Built-in Neovim 0.12+ :Undotree command
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Toggle Undo Tree" })


-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Clipboard: prefer a native OS tool (pbcopy/pbpaste on macOS, win32yank.exe
-- on WSL, xclip/xsel/wl-copy on Linux) when Platform finds one reachable --
-- that's a direct subprocess call, so it works the same whether nvim runs
-- bare or inside tmux. When no native tool is reachable (e.g. inside a
-- container shell), copy falls back to OSC 52: a one-way escape sequence
-- that still reaches the real host clipboard through tmux/docker-exec
-- passthrough. Paste has no such fallback -- OSC 52 paste needs the terminal
-- to answer a query sequence, which Windows Terminal/Terminal.app/iTerm2
-- don't support, so it would just hang for ~10s. Instead it fails fast and
-- tells you to use the terminal's native paste shortcut.
local osc52 = require("vim.ui.clipboard.osc52")

local function make_copy(reg)
    local native = Platform.native_copy_cmd()
    if native then
        return function(lines)
            vim.fn.system(native, lines)
        end
    end
    return osc52.copy(reg)
end

local function make_paste()
    local native = Platform.native_paste_cmd()
    if native then
        return function()
            return vim.fn.systemlist(native)
        end
    end
    return function()
        vim.notify(
            "No system clipboard reader here (e.g. inside a container) -- use the terminal's native paste (Ctrl+Shift+V / Cmd+V) instead",
            vim.log.levels.WARN
        )
        return { "" }
    end
end

vim.g.clipboard = {
    name = "native-or-osc52-copy",
    copy = { ["+"] = make_copy("+"), ["*"] = make_copy("*") },
    paste = { ["+"] = make_paste(), ["*"] = make_paste() },
}

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

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>w", ":wa<CR>")
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down and set cursor to centered", noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up and set cursor to centered", noremap = true })

-- move selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, opts)

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- copy fiel relative path
-- Copy relative path to system clipboard with visual confirmation
vim.keymap.set("n", "<leader>1", function()
  -- Force path to be relative to Neovim's current working directory
  local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Copied relative path: " .. relative_path, vim.log.levels.INFO)
end, { desc = "Copy relative path to clipboard" })
