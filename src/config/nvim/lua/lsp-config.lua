vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})
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

vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.nixos.options",
				},
			},
		},
	},
})

-- Daftar seluruh server yang ingin diaktifkan
local servers = {
	"lua_ls",
	"nixd",
	"vtsls",
	"tailwindcss",
	"svelte",
	"emmet_ls",
	"css",
	"astro",
	"clangd",
	"pyright",
	"ruff",
	"zls",
	"kotlin_lsp",
}

-- Melakukan perulangan untuk mengaktifkan setiap server
for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
