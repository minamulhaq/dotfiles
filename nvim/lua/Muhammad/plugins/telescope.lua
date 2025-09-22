local M = {}
if Platform.is_not_vscode then
    M = {
        {
            "nvim-telescope/telescope.nvim",
            cond = Platform.is_not_vscode,
            branch = "0.1.x",

            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
                "nvim-tree/nvim-web-devicons",
            },

            config = function()
                local telescope = require("telescope")
                local actions = require("telescope.actions")
                local builtin = require("telescope.builtin")
                telescope.load_extension("fzf")

                telescope.setup({
                    defaults = {
                        path_display = { "smart" },
                        mappings = {
                            i = {
                                ["<C-k>"] = actions.move_selection_previous,
                                ["<C-j>"] = actions.move_selection_next,
                            },
                        },
                    },
                })
                vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
                vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
                vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
                vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
                vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "Telescope help tags" })
                vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope help tags" })
                vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope help tags" })
                vim.keymap.set("n", "<leader>kmaps", builtin.keymaps, { desc = "Telescope help tags" })
                vim.keymap.set("n", "<leader>pWs", function()
                    local word = vim.fn.expand("<cWORD>")
                    builtin.grep_string({ search = word })
                end, { desc = "Find Connected Words under cursor" })
            end,
        },
        {
            "nvim-telescope/telescope-ui-select.nvim",
            cond = Platform.is_not_vscode,
            config = function()
                -- This is your opts table
                require("telescope").setup({
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown({
                                -- even more opts
                            }),

                            -- pseudo code / specification for writing custom displays, like the one
                            -- for "codeactions"
                            -- specific_opts = {
                            --   [kind] = {
                            --     make_indexed = function(items) -> indexed_items, width,
                            --     make_displayer = function(widths) -> displayer
                            --     make_display = function(displayer) -> function(e)
                            --     make_ordinal = function(e) -> string
                            --   },
                            --   -- for example to disable the custom builtin "codeactions" display
                            --      do the following
                            --   codeactions = false,
                            -- }
                        },
                    },
                })
                -- To get ui-select loaded and working with telescope, you need to call
                -- load_extension, somewhere after setup function:
                require("telescope").load_extension("ui-select")
            end,
        },
    }
else
    local vscode = assert(Platform.vscode_api.api)
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>ff", function()
        vscode.action("workbench.action.quickOpen")
    end, opts)

    vim.keymap.set("n", "<leader>fg", function()
        vscode.action("workbench.action.findInFiles")
    end)

    vim.keymap.set("n", "<leader>fb", function()
        vscode.action("workbench.action.showAllEditors")
    end)

    vim.keymap.set("n", "<leader>fh", function()
        -- TODO: FIX THIS
    end)

    -- vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "Telescope help tags" })
    vim.keymap.set("n", "<leader>fi", function()
        -- TODO: FIX THIS
    end)

    vim.keymap.set("n", "<leader>fs", function()
        vscode.action("workbench.action.showAllSymbols")
    end)


    -- vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope help tags" })
    vim.keymap.set({ "n", "v" }, "<leader>fw", function()
        local txt = ""
        if vim.fn.mode() == "v" then
            ---@diagnostic disable-next-line: undefined-field
            local selection = vscode.eval("return vscode.window.activeTextEditor.selection")
            if selection and not selection.isEmpty then
                ---@diagnostic disable-next-line: undefined-field
                txt = vscode.eval(
                    "return vscode.window.activeTextEditor.document.getText(vscode.window.activeTextEditor.selection)"
                )
            end
        else
            txt = vim.fn.expand("<cword>")
        end
        require("vscode").action("workbench.action.findInFiles", {
            args = {
                query = vim.fn.expand(txt),
            },
        })
    end, {
        noremap = true,
        silent = true,
        desc = "Find in files for word or selection",
    })
end

return M
