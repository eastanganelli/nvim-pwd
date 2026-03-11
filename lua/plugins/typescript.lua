return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  -- Disable ts_ls from the LazyVim extra in favor of typescript-tools.nvim
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = { enabled = false },
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    },
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufRead package.json",
    keys = {
      { "<leader>ns", function() require("package-info").show() end, desc = "Show Package Info" },
      { "<leader>nu", function() require("package-info").update() end, desc = "Update Package" },
      { "<leader>ni", function() require("package-info").install() end, desc = "Install Package" },
      { "<leader>nd", function() require("package-info").delete() end, desc = "Delete Package" },
      { "<leader>np", function() require("package-info").change_version() end, desc = "Change Version" },
    },
    opts = {
      package_manager = "bun",
    },
  },
}
