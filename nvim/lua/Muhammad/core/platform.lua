---@diagnostic disable: undefined-field
local M = {}

local uv = vim.uv or vim.loop
local uname = uv.os_uname().sysname

M.is_windows = uname == "Windows_NT"
M.is_macos = uname == "Darwin"
M.is_linux = uname == "Linux"

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

return M
