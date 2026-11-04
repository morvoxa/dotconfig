vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
map("n", "<leader>w", ":w<cr>", {})
map("n", "<leader>q", ":q<cr>", {})
map("i", "jk", "<Esc>", {})
