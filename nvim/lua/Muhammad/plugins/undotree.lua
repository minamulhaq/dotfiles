return {
    {
        "mbbill/undotree",
        cond = Platform.is_not_vscode,
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
}
