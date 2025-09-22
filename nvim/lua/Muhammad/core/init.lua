_G.Platform = require("Muhammad.core.platform")
require("Muhammad.core.options")
require("Muhammad.core.remap")
if Platform.is_not_vscode then
    require("Muhammad.core.lsp")
else
    require("Muhammad.core.vscode_lsp_remap")
end
