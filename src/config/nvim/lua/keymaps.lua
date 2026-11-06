vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
map("n", "<leader>w", ":w<cr>", {})
map("n", "<leader>q", ":q<cr>", {})
map("n", "<leader>b", ":bd<cr>", {})
map("i", "jk", "<Esc>", {})
