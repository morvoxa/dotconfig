vim.pack.add({
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
})
require("nvim-autopairs").setup()
require("fidget").setup()
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })
require("nvim-ts-autotag").setup({})
