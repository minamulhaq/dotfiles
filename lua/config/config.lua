local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}



local opts = {
    noremap = true,
    silent = true
}
require("config.nvim_config")


-- Load OS-specific remap files
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_macos = vim.loop.os_uname().sysname == "Darwin"

if is_windows then
    print("windows confs loading")
    local ok, err = pcall(require, "config.win.config_win")
    if not ok then
        vim.notify("Failed to load config.win.config_win.lua: " .. err, vim.log.levels.ERROR)
    end
elseif is_macos then
    local ok, err = pcall(require, "config.osx.config_osx")
    if not ok then
        vim.notify("Failed to load config.osx.config_osx: " .. err, vim.log.levels.ERROR)
    end
end




