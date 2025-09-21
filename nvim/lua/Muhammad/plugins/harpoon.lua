return {
    "ThePrimeagen/harpoon",
    cond = not vim.g.vscode,
    branch = "harpoon2",
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            global_settings = {
                save_on_toggle = true,
                save_on_change = true,
            },
        })
        vim.keymap.set("n", "<leader>he", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon list" })
        --
        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end, { desc = "Harpoon add file" })
        vim.keymap.set("n", "<leader>hm", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon menu" })
        vim.keymap.set("n", "<leader>h1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon file 1" })
        vim.keymap.set("n", "<leader>h2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon file 2" })
        vim.keymap.set("n", "<leader>h3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon file 3" })
        vim.keymap.set("n", "<leader>h4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon file 4" })
        vim.keymap.set("n", "<leader>hp", function()
            harpoon:list():prev()
        end, { desc = "Harpoon prev" })
        vim.keymap.set("n", "<leader>hn", function()
            harpoon:list():next()
        end, { desc = "Harpoon next" })

        vim.keymap.set("n", "<leader>hd", function() end, { desc = "Harpoon remove" })

        -- -- basic telescope configuration
        -- local conf = require("telescope.config").values
        -- local function toggle_telescope(harpoon_files)
        -- 	local file_paths = {}
        -- 	for _, item in ipairs(harpoon_files.items) do
        -- 		table.insert(file_paths, item.value)
        -- 	end
        --
        -- 	require("telescope.pickers")
        -- 		.new({}, {
        -- 			prompt_title = "Harpoon",
        -- 			finder = require("telescope.finders").new_table({
        -- 				results = file_paths,
        -- 			}),
        -- 			previewer = conf.file_previewer({}),
        -- 			sorter = conf.generic_sorter({}),
        -- 		})
        -- 		:find()
        -- end
        --
        -- vim.keymap.set("n", "<C-e>", function()
        -- 	toggle_telescope(harpoon:list())
        -- end, { desc = "Open harpoon window" })
    end,
}
