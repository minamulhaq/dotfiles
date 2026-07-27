-- ~/.config/nvim-new/lua/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})


-- Disable mini.completion inside Snacks Picker input
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function()
    -- Disable mini.completion for this buffer
    vim.b.minicompletion_disable = true
    -- Disable Neovim's native auto-completion flag
    vim.b.completion = false
  end,
})
