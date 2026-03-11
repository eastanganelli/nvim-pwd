return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Languages
        "c", "cpp", "typescript", "tsx", "javascript", "python", "dart", "lua",
        -- Web
        "html", "css", "scss", "json", "json5", "jsonc", "yaml", "toml",
        -- Build tools
        "cmake", "make", "ninja",
        -- Scripting
        "bash", "fish", "powershell",
        -- Documentation
        "markdown", "markdown_inline", "vimdoc", "comment",
        -- Git
        "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
        -- Others
        "query", "regex", "vim", "sql",
      })
      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, { enable = true })
      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, { enable = true })
      opts.incremental_selection = vim.tbl_deep_extend("force", opts.incremental_selection or {}, {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      })
    end,
  },
}
