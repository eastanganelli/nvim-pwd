local is_windows = vim.loop.os_uname().sysname == "Windows_NT"

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- DAP signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◎", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- C/C++ with codelldb
      local codelldb_path
      if is_windows then
        codelldb_path = vim.fn.stdpath("data") .. "\\mason\\bin\\codelldb.cmd"
      else
        codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Launch with arguments",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Python with debugpy
      local debugpy_path
      if is_windows then
        debugpy_path = vim.fn.stdpath("data") .. "\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe"
      else
        debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      end

      dap.adapters.python = {
        type = "executable",
        command = debugpy_path,
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          name = "Launch file",
          type = "python",
          request = "launch",
          program = "${file}",
          pythonPath = function()
            if is_windows then
              if vim.fn.executable(vim.fn.getcwd() .. "\\.venv\\Scripts\\python.exe") == 1 then
                return vim.fn.getcwd() .. "\\.venv\\Scripts\\python.exe"
              end
            else
              if vim.fn.executable(vim.fn.getcwd() .. "/.venv/bin/python") == 1 then
                return vim.fn.getcwd() .. "/.venv/bin/python"
              end
            end
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end,
        },
      }

      -- JavaScript/TypeScript with pwa-node and pwa-chrome
      local js_debug_path
      if is_windows then
        js_debug_path = vim.fn.stdpath("data")
          .. "\\mason\\packages\\js-debug-adapter\\js-debug\\src\\dapDebugServer.js"
      else
        js_debug_path = vim.fn.stdpath("data")
          .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
      end

      for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_debug_path, "${port}" },
          },
        }
      end

      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = {
          {
            name = "Launch Node.js",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            name = "Attach to Node.js",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            name = "Launch Chrome",
            type = "pwa-chrome",
            request = "launch",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
          },
          {
            name = "Debug Next.js",
            type = "pwa-chrome",
            request = "launch",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            sourceMapPathOverrides = {
              ["webpack://_N_E/*"] = "${workspaceFolder}/*",
            },
          },
        }
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "codelldb", "debugpy", "js-debug-adapter" },
      automatic_installation = true,
    },
  },
}
