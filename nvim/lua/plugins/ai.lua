-- Claude Code integration (coder/claudecode.nvim).
-- Requires the Claude Code CLI (`claude`) to be installed and on the PATH that Neovim sees.
-- Run `:checkhealth claudecode` if something doesn't connect.
--
-- How it works: <leader>ac opens Claude Code in a side terminal; Claude sees your current file and
-- selection, opens files, and proposes edits as a native Neovim diff.
--   accept a diff:  :w  or  <leader>aa        reject:  :q  or  <leader>ad

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSelectModel", "ClaudeCodeAdd", "ClaudeCodeSend",
      "ClaudeCodeTreeAdd", "ClaudeCodeStatus", "ClaudeCodeStart", "ClaudeCodeStop", "ClaudeCodeOpen",
      "ClaudeCodeClose", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny", "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last Claude session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to context" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file to Claude context",
        ft = { "neo-tree", "oil", "NvimTree", "minifiles", "netrw", "snacks_picker_list" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    opts = {
      -- If `claude` is not found from inside Neovim (e.g. a custom install path), set it here:
      -- terminal_cmd = "~/.claude/local/claude",
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
      },
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = false,
      },
    },
  },
}
