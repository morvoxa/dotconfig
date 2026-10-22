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
  map("n", "<C-j>", ':lua require("vscode").action("workbench.action.terminal.toggleTerminal")<cr>', { silent = true })
  map("n", "<leader>w", ':lua require("vscode").action("workbench.action.files.save")<cr>', { silent = true })
  map("n", "H", ':lua require("vscode").action("workbench.action.previousEditor")<cr>', { silent = true })
  map("n", "L", ':lua require("vscode").action("workbench.action.nextEditor")<cr>', { silent = true })
  map("n", "<leader>nh", ":nohl<cr>", { silent = true })
else
  require("config.lazy")
end
