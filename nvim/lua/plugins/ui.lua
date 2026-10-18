-- Look & feel: colorscheme, statusline, bufferline, which-key, icons.

return {
  -- Colorscheme --------------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false, -- load at startup so the theme is ready before anything draws
    priority = 1000,
    opts = {
      style = "night", -- "storm" | "moon" | "night" | "day"
      styles = { sidebars = "dark", floats = "dark" },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Icons (Nerd Font required) ---------------------------------------------
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline ---------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}", unnamed = "[No Name]" } },
          {
            "diagnostics",
            symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "\u{f0eb} " },
          },
        },
        lualine_x = {
          { "diff", source = function()
              local gs = vim.b.gitsigns_status_dict
              if gs then return { added = gs.added, modified = gs.changed, removed = gs.removed } end
            end,
          },
          -- Show which LSP servers are attached to the current buffer
          {
            function()
              local names = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                table.insert(names, client.name)
              end
              return #names > 0 and ("\u{f085} " .. table.concat(names, ",")) or ""
            end,
          },
        },
        lualine_y = { "filetype", "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy", "mason", "trouble", "quickfix" },
    },
  },

  -- Bufferline ---------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },

  -- Keymap discovery ---------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "ai (Claude Code)", icon = "\u{f544}" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>D", group = "docker", icon = "\u{f308}" },
        { "<leader>f", group = "find / files" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
        { "<leader>n", group = "notifications" },
        { "<leader>o", group = "obsidian", icon = "\u{f249}" },
        { "<leader>q", group = "session / quit" },
        { "<leader>r", group = "run tasks" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "ui toggles" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics / quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps (which-key)" },
    },
  },
}
