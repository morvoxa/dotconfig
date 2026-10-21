require "nvchad.options"
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 4
opt.expandtab = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.inccommand = "split"
opt.iskeyword:append "-"
