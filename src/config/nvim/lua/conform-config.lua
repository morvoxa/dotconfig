vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
