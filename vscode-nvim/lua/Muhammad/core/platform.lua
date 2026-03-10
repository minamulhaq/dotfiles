---@diagnostic disable: undefined-field
local M = {}

local uv = vim.uv or vim.loop
local uname = uv.os_uname().sysname

M.is_windows = uname == "Windows_NT"
M.is_macos = uname == "Darwin"
M.is_linux = uname == "Linux"

---@class VSCodeAPI
---@field call function
---@field action function
---@field notify function
M.vscode_api = {
    ---@type VSCodeAPI|nil
    api = nil,
    MoveCurrentLineToCenter = function() end
}

local ok, vscode = pcall(require, "vscode")
if ok then
    M.vscode_api.api = vscode
else
    print("Couldn't set vscode api")
end

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

function M.vscode_api.add_selection_to_next()
    M.vscode_api.api.with_insert(function()
        M.vscode_api.api.action("editor.action.addSelectionToNextFindMatch")
    end)
end

return M
