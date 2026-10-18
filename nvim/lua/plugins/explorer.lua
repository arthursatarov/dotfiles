-- Classic file tree (neo-tree).  <leader>e toggles it, <leader>E reveals the current file.

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (toggle)" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Explorer (reveal current file)" },
      { "<leader>ge", "<cmd>Neotree git_status float<cr>", desc = "Git status tree" },
      { "<leader>be", "<cmd>Neotree buffers float<cr>", desc = "Buffers tree" },
    },
    -- Open the tree when starting `nvim <directory>` (netrw is disabled).
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("user_neotree_start", { clear = true }),
        callback = function(args)
          local path = vim.api.nvim_buf_get_name(args.buf)
          if path ~= "" and vim.fn.isdirectory(path) == 1 then
            vim.cmd("Neotree position=current dir=" .. vim.fn.fnameescape(path))
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      close_if_last_window = true,
      popup_border_style = "rounded",
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          visible = true, -- show hidden entries dimmed instead of hiding them
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".DS_Store", ".git" },
        },
      },
      window = {
        width = 34,
        mappings = {
          ["<space>"] = "none", -- keep <Space> as the leader inside the tree
          ["l"] = "open",
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              vim.fn.setreg("+", node:get_id())
              vim.notify("Copied: " .. node:get_id())
            end,
            desc = "Copy absolute path",
          },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "▸", expander_expanded = "▾" },
        git_status = {
          symbols = {
            added = "✚", modified = "●", deleted = "✖", renamed = "➜",
            untracked = "★", ignored = "◌", unstaged = "✗", staged = "✓", conflict = "‼",
          },
        },
      },
      event_handlers = {
        -- Make renames/moves done in the tree update imports through the LSP.
        {
          event = "file_moved",
          handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
        },
        {
          event = "file_renamed",
          handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
        },
      },
    },
  },
}
