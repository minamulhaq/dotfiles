return{
	"ellisonleao/gruvbox.nvim",
    cond = not vim.g.vscode,
	 priority = 1000 ,
config = function()
	vim.o.background = "dark" -- or "light" for light mode
	vim.cmd([[colorscheme gruvbox]])
end ,
opts = {}}
