-- Task runner: run npm scripts (which usually wrap gulp / webpack / vite), composer scripts
-- and Makefile targets from Neovim, with output in a panel.
--   <leader>rr  pick a task and run it       <leader>rt  toggle the task list
--   <leader>ra  task actions (restart, stop, open output, ...)
-- Tip: if your gulp tasks are not exposed as npm scripts, use `:OverseerShell npx gulp <task>`.

return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerShell", "OverseerTaskAction" },
    keys = {
      { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>ra", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      { "<leader>rs", "<cmd>OverseerShell<cr>", desc = "Run shell command as task" },
    },
    opts = {
      dap = false, -- we configure nvim-dap ourselves
      task_list = { direction = "bottom", min_height = 12, max_height = 25 },
      component_aliases = {
        default = {
          "on_exit_set_status",
          { "on_complete_notify", system = "unfocused" },
        },
      },
    },
  },
}
