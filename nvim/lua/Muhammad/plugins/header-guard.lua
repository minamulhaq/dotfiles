return {
    "minamulhaq/header-guard",
    event = "VeryLazy",
    cond = Platform.is_not_vscode,
    config = function()
        require("header-guard")
    end,
}
