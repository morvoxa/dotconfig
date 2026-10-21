return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lua_ls = {
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
      },
      nixd = {
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
      },
      vtsls = {},
      tailwindcss = {},
      svelte = {},
      emmet_ls = {},
      css = {},
      clangd = {},
      pyright = {},
      ruff = {},
      zls = {},
    },
  },
}
