-- os.lua
local M = {}

-- Handle both old and new Neovim APIs for compatibility
local uv = vim.uv or vim.loop
local uname = uv.os_uname().sysname

M.is_windows = uname == "Windows_NT"
M.is_macos = uname == "Darwin"
M.is_linux = uname == "Linux"
-- VSCode detection with safe module loading
M.is_vscode = vim.g.vscode
M.is_not_vscode = vim.g.vscode == nil



---@class VSCodeAPI
---@field call function
---@field action function
---@field notify function
M.vscode_api = {
    ---@type VSCodeAPI|nil
    api = nil,
    MoveCurrentLineToCenter = function() end
}


if M.is_vscode then
    vim.notify("Setting vscode")
    local ok, vscode = pcall(require, "vscode")
    if ok then
        vim.notify("Vscode is properly set")
        M.vscode_api.api = vscode
    else
        print("Couldn't set vscode api")
        M.vscode_api.api = nil
    end
end

-- Convenience function
function M.get_os()
    if M.is_windows then
        return "windows"
    elseif M.is_macos then
        return "macos"
    elseif M.is_linux then
        return "linux"
    else
        return "unknown"
    end
end

function M.vscode_api.MoveCurrentLineToCenter()
    if M.vscode_api.api then
        local line = vim.fn.line(".")
        M.vscode_api.api.call("revealLine", { args = { lineNumber = line, at = "center" } })
    end
end

return M
