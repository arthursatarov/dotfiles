-- Databases (vim-dadbod): the SQLTools replacement. MySQL / MariaDB and PostgreSQL.
-- Needs the client CLIs on PATH:  brew install mysql-client libpq   (both keg-only, see .zprofile)
--
--   <leader>Db  toggle the DB UI (connections, tables, saved queries)
--   In a query buffer: <leader>S runs the buffer / selection, results open in a split.
--
-- Connections: add them in the UI (`A`, saved to ~/.local/share/db_ui), or per project in `.nvim.lua`:
--     vim.g.dbs = { { name = "wp", url = "mysql://root:root@127.0.0.1:3306/wordpress" } }
-- Ports are whatever docker compose publishes on the host.

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>Db", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 34
      vim.g.db_ui_auto_execute_table_helpers = 1
    end,
  },

  -- Table / column completion in SQL buffers.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
          mysql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
}
