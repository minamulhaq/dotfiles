vim.g.mapleader = " "  -- Set leader key to space

require("config.remap")
require("config.config")

if vim.g.vscode then
    require("config.vscode_config")
else
end
require("config.lazy")