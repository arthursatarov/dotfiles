-- Neovim config for web development (PHP / WordPress / Drupal / JS / SCSS),
-- Git, Docker and Obsidian.  Requires Neovim >= 0.11 (tested on 0.12).
--
-- Layout:
--   lua/config/*   core settings (options, keymaps, autocmds, filetypes, lazy.nvim bootstrap)
--   lua/plugins/*  one lazy.nvim spec file per topic

-- Leaders must be set before any plugin or mapping is loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.filetypes")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
