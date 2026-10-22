-- Task runner: run npm scripts (which usually wrap gulp / webpack / vite), composer scripts
-- and Makefile targets from Neovim, with output in a panel.
--   <leader>rr  pick a task and run it       <leader>rt  toggle the task list
--   <leader>ra  task actions (restart, stop, open output, ...)
-- Tip: if your gulp tasks are not exposed as npm scripts, use `:OverseerShell npx gulp <task>`.
--   <leader>rf  run the current file (like Code Runner), output in a terminal split

local runners = {
  php = "php",
  javascript = "node",
  typescript = "npx --yes tsx",
  sh = "bash",
  bash = "bash",
  zsh = "zsh",
  lua = "nvim -l",
  python = "python3",
}

local function run_file()
  local cmd = runners[vim.bo.filetype]
  if not cmd then
    vim.notify("No runner for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  vim.cmd("silent update")
  local script = cmd .. " " .. vim.fn.shellescape(vim.fn.expand("%:p")) .. "; echo; read -sk '?[done, any key closes]'"
  Snacks.terminal.open({ "zsh", "-c", script }, {
    cwd = vim.fn.expand("%:p:h"),
    win = { position = "bottom", height = 0.3 },
  })
end

return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>rf", run_file, desc = "Run current file" },
    },
  },

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
