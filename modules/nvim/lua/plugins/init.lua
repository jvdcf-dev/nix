-- Initialization of the plugins
-- See https://nvchad.com/docs/config/plugins/

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "rust-analyzer",
        "clangd",
        "python-lsp-server",
        "phpactor",
        "rnix-lsp"
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "rust",
        "c",
        "cpp",
        "python",
        "php",
        "sql",
        "java",
        "javascript",
        "make",
        "cmake",
        "git_config",
        "gitignore",
        "gitattributes",
        "ssh_config",
        "yaml",
        "toml",
        "bash",
        "nix",
      },
    },
  },

  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    opts = {
      execution_message = {
        message = "",
        dim = 0.18,
        cleaning_internal = 1250,
      },
    },
  },

  {
    "github/copilot.vim",
    lazy = false,
  }
}
