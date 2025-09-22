return {
    "minamulhaq/header-guard",
    cond = Platform.is_not_vscode,
    config = function()
        require("header-guard")
    end,
}
