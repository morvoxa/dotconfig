vim.env.CC = "gcc"
require("config.keymaps")
require("config.options")
require("config.lazy")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})
