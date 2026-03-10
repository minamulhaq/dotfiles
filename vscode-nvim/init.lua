require("Muhammad.core")
require("Muhammad.lazy")

vim.schedule(function()
    if Platform.vscode_api.api then
        Platform.vscode_api.api.notify("vscode-nvim loaded")
    end
end)
