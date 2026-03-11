return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        html = {},
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        yamlls = {},
        cmake = {},
        lua_ls = {},
        eslint = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "clangd",
        "typescript-language-server",
        "pyright",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "json-lsp",
        "yaml-language-server",
        "cmake-language-server",
        "lua-language-server",
        "eslint-lsp",
        -- Formatters
        "stylua",
        "prettier",
        "black",
        "isort",
        "clang-format",
        "cmake-format",
        -- Linters
        "eslint_d",
        "flake8",
        "pylint",
        "cmakelint",
        -- DAP adapters
        "codelldb",
        "debugpy",
        "js-debug-adapter",
      },
    },
  },
}
