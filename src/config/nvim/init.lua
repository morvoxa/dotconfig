if vim.g.vscode then
	vim.opt.clipboard = "unnamedplus"
	vim.opt.smartcase = false
	vim.opt.ignorecase = true
	vim.g.mapleader = " "
	vim.pack.add({
		{ src = "https://github.com/folke/flash.nvim" },
	})
	local map = vim.api.nvim_set_keymap
	vim.keymap.set({ "n", "x", "o" }, "s", function()
		require("flash").jump()
	end, { desc = "Flash" })
	map(
		"n",
		"<C-j>",
		':lua require("vscode").action("workbench.action.terminal.toggleTerminal")<cr>',
		{ silent = true }
	)
	map("n", "<leader>ff", ':lua require("vscode").action("code-telescope.fuzzy.file")<cr>', { silent = true })
	map("n", "<leader>fg", ':lua require("vscode").action("code-telescope.fuzzy.wsText")<cr>', { silent = true })
	map("n", "<leader>fr", ':lua require("vscode").action("code-telescope.fuzzy.recentFiles")<cr>', { silent = true })
	map("n", "<leader>e", ':lua require("vscode").action("oil-code.open")<cr>', { silent = true })
	map("n", "<leader>r", ':lua require("vscode").action("workbench.action.openRecent")<cr>', { silent = true })
	map("n", "<leader>b", ':lua require("vscode").action("workbench.action.closeActiveEditor")<cr>', { silent = true })
	map("n", "<leader>w", ':lua require("vscode").action("workbench.action.files.save")<cr>', { silent = true })
	map("n", "H", ':lua require("vscode").action("workbench.action.previousEditor")<cr>', { silent = true })
	map("n", "L", ':lua require("vscode").action("workbench.action.nextEditor")<cr>', { silent = true })
	map("n", "<leader>nh", ":nohl<cr>", { silent = true })
else
	vim.env.CC = "gcc"
	require("options")
	require("keymaps")
	require("oil-config")
	require("snacks-config")
	require("flash-config")
	require("conform-config")
	require("tree-sitter-config")
	require("lsp-config")
	require("blink-config")
	require("etc-config")
end
