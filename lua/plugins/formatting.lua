return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        tsx = { "prettier" },
        jsx = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        python = { "isort", "black" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmake_format" },
        dart = { "dart_format" },
        sql = { "sql_formatter" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        prettier = {
          prepend_args = { "--single-quote" },
        },
        black = {
          prepend_args = { "--line-length", "100" },
        },
        clang_format = {
          prepend_args = { "--fallback-style=Google" },
        },
      },
    },
  },
}
