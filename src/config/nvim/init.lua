if vim.g.vscode then
	local o = vim.opt
	o.clipboard = "unnamedplus"
	o.ignorecase = true
	o.smartcase = true
	o.incsearch = true
	o.inccommand = "split"
	o.iskeyword:append("-")
	o.timeoutlen = 300
	local vscode = require("vscode")
	vim.g.mapleader = " "
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
	})
	local flash = require("flash")
	vim.keymap.set({ "n", "x", "o" }, "s", function()
		flash.jump()
	end, { desc = "Flash" })
	vim.keymap.set("n", "<leader>r", function()
		vscode.action("workbench.action.openRecent")
	end, { desc = "Open Recent", silent = true })
	vim.keymap.set("n", "<leader>w", function()
		vscode.action("workbench.action.files.save")
	end, { desc = "Save File", silent = true })
	vim.keymap.set("n", "<C-j>", function()
		vscode.action("workbench.action.terminal.toggleTerminal")
	end, { silent = true })
	vim.keymap.set("n", "H", function()
		vscode.action("workbench.action.previousEditor")
	end, { desc = "Buffer sebelumnya", silent = true })
	vim.keymap.set("n", "L", function()
		vscode.action("workbench.action.nextEditor")
	end, { desc = "Buffer selanjutnya", silent = true })
else
	require("config.lazy")
end
