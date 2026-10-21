require "nvchad.autocmds"
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
