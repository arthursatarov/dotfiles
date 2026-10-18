-- Obsidian inside Neovim: obsidian.nvim (links, backlinks, daily notes, templates, search)
-- + render-markdown.nvim (pretty in-buffer rendering of headings, checkboxes, tables, callouts).
--
-- >>> SET YOUR VAULT PATH <<<
-- Either edit `vault_path` below, or export OBSIDIAN_VAULT in your shell profile:
--     export OBSIDIAN_VAULT="$HOME/Documents/Obsidian/MyVault"
-- The vault stays 100% compatible with the Obsidian desktop app.

local vault_path = vim.env.OBSIDIAN_VAULT or "~/Documents/Obsidian/Vault" -- TODO: replace with the real path

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- latest release
    -- Load only for markdown files inside the vault (fast startup), plus the :Obsidian command.
    cmd = "Obsidian",
    event = {
      "BufReadPre " .. vim.fn.expand(vault_path) .. "/**.md",
      "BufNewFile " .. vim.fn.expand(vault_path) .. "/**.md",
    },
    keys = {
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Open note (quick switch)" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes (grep)" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
      { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily note" },
      { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Daily notes list" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in this note" },
      { "<leader>og", "<cmd>Obsidian tags<cr>", desc = "Tags" },
      { "<leader>oc", "<cmd>Obsidian toc<cr>", desc = "Table of contents" },
      { "<leader>oT", "<cmd>Obsidian template<cr>", desc = "Insert template" },
      { "<leader>oN", "<cmd>Obsidian new_from_template<cr>", desc = "New note from template" },
      { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard" },
      { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note (updates backlinks)" },
      { "<leader>ox", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },
      { "<leader>oO", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
      { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Switch vault / workspace" },
      { "<leader>oe", "<cmd>Obsidian extract_note<cr>", mode = "v", desc = "Extract selection to new note" },
      { "<leader>oL", "<cmd>Obsidian link<cr>", mode = "v", desc = "Link selection to a note" },
      { "<leader>oK", "<cmd>Obsidian link_new<cr>", mode = "v", desc = "Link selection to a NEW note" },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- use the single `:Obsidian <subcommand>` entry point
      workspaces = {
        { name = "vault", path = vault_path },
        -- { name = "work", path = "~/Documents/Obsidian/Work" },
      },
      picker = { name = "snacks.picker" },
      notes_subdir = nil, -- e.g. "Inbox" to put new notes there
      daily_notes = {
        folder = "Daily",
        date_format = "%Y-%m-%d",
      },
      templates = {
        folder = "Templates",
      },
      -- render-markdown.nvim draws the markdown prettily, so obsidian.nvim's own UI is disabled.
      ui = { enable = false },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown rendering" },
    },
    opts = {
      file_types = { "markdown" },
      heading = { sign = false },
      code = { sign = false, width = "block", right_pad = 1 },
      checkbox = { enabled = true },
      -- Show the raw text on the line under the cursor (good for editing links).
      anti_conceal = { enabled = true },
    },
  },
}
