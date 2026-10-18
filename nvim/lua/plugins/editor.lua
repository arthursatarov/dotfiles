-- Everyday editing helpers: surround, fast jumps, TODO comments, diagnostics list, sessions.

return {
  -- Surround (v4: keymaps are bound to <Plug> mappings).
  --   gsa{motion}{char} add   gsaa line   gsd{char} delete   gsr{old}{new} replace   (visual: gsa)
  -- Not using the default ys/ds/cs because `s` is taken by flash.nvim in operator-pending mode.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function() vim.g.nvim_surround_no_mappings = true end,
    config = function()
      require("nvim-surround").setup({})
      local map = vim.keymap.set
      map("n", "gsa", "<Plug>(nvim-surround-normal)", { desc = "Add surround (motion)" })
      map("n", "gsaa", "<Plug>(nvim-surround-normal-cur)", { desc = "Add surround (line)" })
      map("n", "gsA", "<Plug>(nvim-surround-normal-line)", { desc = "Add surround on new lines (motion)" })
      map("n", "gsAA", "<Plug>(nvim-surround-normal-cur-line)", { desc = "Add surround on new lines (line)" })
      map("x", "gsa", "<Plug>(nvim-surround-visual)", { desc = "Add surround (selection)" })
      map("x", "gsA", "<Plug>(nvim-surround-visual-line)", { desc = "Add surround on new lines (selection)" })
      map("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
      map("n", "gsr", "<Plug>(nvim-surround-change)", { desc = "Replace surround" })
      map("i", "<C-g>s", "<Plug>(nvim-surround-insert)", { desc = "Add surround (insert)" })
    end,
  },

  -- Jump anywhere on screen with 2-3 keystrokes.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle flash search" },
    },
  },

  -- Highlight and list TODO / FIXME / HACK comments.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODO list (Trouble)" },
    },
  },

  -- Pretty diagnostics / references / quickfix lists.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols outline" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
    },
  },

  -- Sessions: restore your layout per project directory.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (cwd)" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },
}
