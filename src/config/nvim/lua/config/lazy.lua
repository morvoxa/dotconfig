-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>w", ":w<cr>", {})
vim.api.nvim_set_keymap("i", "jk", "<esc>", {})
vim.api.nvim_set_keymap("n", "<leader>x", ":bd<cr>", {})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", {})
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>w", {})
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", {})
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 4
opt.expandtab = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 0

vim.keymap.set("n", "<leader>t", ":botright new | resize 15 | terminal<CR>", { desc = "Open Horizontal Terminal" })
vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})

local ts_native_group = vim.api.nvim_create_augroup("TSNativeHighlight", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = ts_native_group,
	pattern = {
		"rust",
		"zig",
		"typescript",
		"javascript",
		"typescriptreact",
		"javascriptreact",
		"astro",
		"html",
		"css",
		"scss",
		"svelte",
		"c",
		"cpp",
		"go",
		"cmake",
		"lua",
		"python",
		"sh",
		"markdown",
		"toml",
		"kdl",
		"yaml",
		"json",
		"ini",
		"dockerfile",
	},
	callback = function()
		vim.treesitter.start()
	end,
})
