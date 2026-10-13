return {
	"neovim/nvim-lspconfig",
	opts = {},
	config = function()
		local servers =
			{ "lua_ls", "vtsls", "tailwindcss", "svelte", "emmet_ls", "css", "clangd", "pyright", "ruff", "zls" }

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
						},
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		vim.lsp.config("tailwindcss", {
			filetypes = { "svelte", "javascript", "typescript", "javascriptreact", "typescriptreact" },
		})

		for _, server in ipairs(servers) do
			vim.lsp.enable(server)
		end
	end,
}
