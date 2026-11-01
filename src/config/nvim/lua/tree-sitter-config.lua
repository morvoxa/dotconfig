vim.pack.add({
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
})
require("tree-sitter-manager").setup({
	auto_install = true,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})
