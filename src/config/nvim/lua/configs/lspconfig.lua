require("nvchad.configs.lspconfig").defaults()

local servers = {
  "lua_ls",
  "nixd",
  "vtsls",
  "tailwindcss",
  "svelte",
  "emmet_ls",
  "css",
  "clangd",
  "pyright",
  "ruff",
  "zls",
}

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
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
