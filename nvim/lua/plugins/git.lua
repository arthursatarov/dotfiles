-- Git: gutter signs + hunk actions (gitsigns), side-by-side diffs and history (diffview).
-- Lazygit and git pickers live in snacks.lua (<leader>g*).

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▁" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▁" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function m(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        m("n", "]h", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "Next hunk")
        m("n", "[h", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "Prev hunk")

        m({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
        m({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
        m("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        m("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        m("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        m("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
        m("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
        m("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle inline blame")
        m("n", "<leader>hd", gs.diffthis, "Diff against index")
        m("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")
        m({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Select hunk")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view (working tree)" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (diffview)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history (diffview)", mode = "v" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = "diff3_mixed" }, -- 3-way merge conflict resolution
      },
    },
  },
}
