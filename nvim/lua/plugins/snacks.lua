-- snacks.nvim: picker (files / grep / LSP), lazygit, terminal, notifications,
-- dashboard, indent guides, word jumps. One plugin instead of ten.

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true }, -- show dotfiles, still respects .gitignore
          grep = { hidden = true },
        },
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { configure = true },
      terminal = {},
      -- Image previews need a terminal with the Kitty graphics protocol (Ghostty, Kitty, WezTerm).
      -- Flip to true if yours supports it.
      image = { enabled = false },
      styles = { notification = { wo = { wrap = true } } },
    },
    keys = {
      -- Top-level shortcuts -------------------------------------------------
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find files (smart)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep project" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      { "<C-_>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },

      -- Find / files --------------------------------------------------------
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim config files" },

      -- Search --------------------------------------------------------------
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word / selection", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (workspace)" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (buffer)" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols (buffer)" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP symbols (workspace)" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last search" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "TODO comments" },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

      -- Git -----------------------------------------------------------------
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit file history" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gL", function() Snacks.picker.git_log() end, desc = "Git log" },

      -- Notifications -------------------------------------------------------
      { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },

      -- Words / scratch -----------------------------------------------------
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
      { "<leader>.", function() Snacks.scratch() end, desc = "Scratch buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Toggle helpers (<leader>u*)
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uH")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark background" }):map("<leader>ub")
          Snacks.toggle.option("conceallevel", { off = 0, on = 2 }):map("<leader>uc")

          -- Rename files with LSP support (updates imports) from any place
          vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename file" })
        end,
      })
    end,
  },
}
