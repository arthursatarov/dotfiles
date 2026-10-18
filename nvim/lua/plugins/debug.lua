-- Debugging (nvim-dap) and tests (neotest), mostly for PHP running in Docker.
--
-- PHP + Xdebug 3 workflow:
--   1. In the container's php.ini:  xdebug.mode=debug
--                                   xdebug.start_with_request=trigger   (or "yes")
--                                   xdebug.client_host=host.docker.internal
--                                   xdebug.client_port=9003
--   2. Map container paths to your project. Default remote root is /var/www/html (DDEV and
--      most images). Override per project in a `.nvim.lua` file:
--          vim.g.php_debug_remote_root = "/var/www/html/web"
--   3. Set a breakpoint (<leader>db), press <leader>dc ("Listen for Xdebug"), then hit the site
--      with the XDEBUG_TRIGGER cookie/param (browser extension "Xdebug helper").

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
      },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Start / continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Toggle debug UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Evaluate expression", mode = { "n", "v" } },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Signs
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      for name, sign in pairs({
        Breakpoint = "●", BreakpointCondition = "◆", BreakpointRejected = "○",
        LogPoint = "◆", Stopped = "▶",
      }) do
        vim.fn.sign_define("Dap" .. name, {
          text = sign,
          texthl = name == "Stopped" and "DiagnosticOk" or "DiagnosticError",
          linehl = name == "Stopped" and "DapStoppedLine" or nil,
          numhl = name == "Stopped" and "DapStoppedLine" or nil,
        })
      end

      -- Open / close the UI automatically with the debug session
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end

      -- PHP (vscode-php-debug, installed by Mason as "php-debug-adapter") ------
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      local remote_root = vim.g.php_debug_remote_root or "/var/www/html"
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug (Docker)",
          port = 9003,
          pathMappings = { [remote_root] = "${workspaceFolder}" },
        },
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug (no path mapping, local PHP)",
          port = 9003,
        },
      }
    end,
  },

  -- Tests: <leader>t*. PHPUnit adapter runs on the HOST (needs local php + vendor/bin/phpunit).
  -- For tests that must run inside a container, use <leader>Dc (docker compose exec ...).
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-phpunit",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-phpunit") },
      })
    end,
  },
}
