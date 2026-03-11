local is_windows = vim.loop.os_uname().sysname == "Windows_NT"

return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    keys = {
      { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Flutter Run" },
      { "<leader>Fr", "<cmd>FlutterReload<cr>", desc = "Hot Reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Hot Restart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Emulators" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Quit" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Outline" },
      { "<leader>Fl", "<cmd>FlutterLspRestart<cr>", desc = "LSP Restart" },
    },
    opts = {
      flutter_path = is_windows and "C:\\flutter\\bin\\flutter.bat" or nil,
      flutter_lookup_cmd = is_windows and nil or "which flutter",
      widget_guides = { enabled = true },
      closing_tags = {
        highlight = "ErrorMsg",
        prefix = "//>",
        enabled = true,
      },
      dev_log = {
        enabled = true,
        notify_errors = false,
        open_cmd = "tabedit",
      },
      lsp = {
        color = {
          enabled = true,
          background = false,
          virtual_text = true,
          virtual_text_str = "■",
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = { vim.fn.expand("$HOME/.pub-cache") },
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(paths)
          local dap = require("dap")
          dap.adapters.dart = {
            type = "executable",
            command = paths.flutter_bin,
            args = { "debug_adapter" },
          }
          dap.configurations.dart = {
            {
              type = "dart",
              request = "launch",
              name = "Launch Flutter",
              dartSdkPath = paths.dart_sdk,
              flutterSdkPath = paths.flutter_sdk,
              program = "${workspaceFolder}/lib/main.dart",
              cwd = "${workspaceFolder}",
            },
            {
              type = "dart",
              request = "launch",
              name = "Launch Flutter (Profile)",
              dartSdkPath = paths.dart_sdk,
              flutterSdkPath = paths.flutter_sdk,
              program = "${workspaceFolder}/lib/main.dart",
              cwd = "${workspaceFolder}",
              flutterMode = "profile",
            },
            {
              type = "dart",
              request = "attach",
              name = "Attach to Flutter",
              deviceId = "flutter-tester",
              cwd = "${workspaceFolder}",
            },
          }
        end,
      },
    },
  },
}
