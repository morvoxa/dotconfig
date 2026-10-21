return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "rust",
        "zig",
        "typescript",
        "javascript",
        "tsx",
        "jsx",
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
        "bash",
        "markdown",
        "markdown_inline",
        "toml",
        "kdl",
        "yaml",
        "json",
        "ini",
        "dockerfile",
        "nix",
      }
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
    },
  },
}
