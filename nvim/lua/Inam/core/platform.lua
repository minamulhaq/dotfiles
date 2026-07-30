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

-- Candidate clipboard tools, tried in order. Not tied to any particular OS
-- check: whatever binary is actually reachable on $PATH wins, so this works
-- unmodified on WSL, macOS, native Linux, and correctly finds nothing (rather
-- than guessing wrong) inside a container/minimal shell with none of these
-- installed.
local COPY_CANDIDATES = {
    { bin = "pbcopy",        cmd = { "pbcopy" } },
    { bin = "win32yank.exe", cmd = { "win32yank.exe", "-i", "--crlf" } },
    { bin = "wl-copy",       cmd = { "wl-copy", "--type", "text/plain" },              needs_env = "WAYLAND_DISPLAY" },
    { bin = "xclip",         cmd = { "xclip", "-quiet", "-i", "-selection", "clipboard" }, needs_env = "DISPLAY" },
    { bin = "xsel",          cmd = { "xsel", "--nodetach", "-i", "-b" },               needs_env = "DISPLAY" },
}

local PASTE_CANDIDATES = {
    { bin = "pbpaste",       cmd = { "pbpaste" } },
    { bin = "win32yank.exe", cmd = { "win32yank.exe", "-o", "--lf" } },
    { bin = "wl-paste",      cmd = { "wl-paste", "--no-newline" },                     needs_env = "WAYLAND_DISPLAY" },
    { bin = "xclip",         cmd = { "xclip", "-o", "-selection", "clipboard" },       needs_env = "DISPLAY" },
    { bin = "xsel",          cmd = { "xsel", "-o", "-b" },                             needs_env = "DISPLAY" },
}

local function first_available(candidates)
    for _, c in ipairs(candidates) do
        if (not c.needs_env or vim.env[c.needs_env]) and vim.fn.executable(c.bin) == 1 then
            return c.cmd
        end
    end
    return nil
end

--- Command to write to the system clipboard directly (bypassing the
--- terminal), or nil if no such tool is reachable from here.
function M.native_copy_cmd()
    return first_available(COPY_CANDIDATES)
end

--- Command to read the system clipboard directly (bypassing the terminal),
--- or nil if no such tool is reachable from here (e.g. inside a container).
function M.native_paste_cmd()
    return first_available(PASTE_CANDIDATES)
end

return M
