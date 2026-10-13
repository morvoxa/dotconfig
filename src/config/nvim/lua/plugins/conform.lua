return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				kdl = { "kdlfmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				cmake = { "gersemi" },
				nix = { "nixfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
