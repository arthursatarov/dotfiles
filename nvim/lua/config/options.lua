-- Core editor options.

local opt = vim.opt

-- Allow per-project overrides in `.nvim.lua` (Neovim asks you to trust the file first).
-- Handy for docker container names, xdebug path mappings, etc.
opt.exrc = true

-- UI -------------------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- the statusline already shows the mode
opt.laststatus = 3 -- one global statusline
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.pumheight = 12
opt.winborder = "rounded"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }
opt.colorcolumn = "" -- set per project via .editorconfig / .nvim.lua if needed

-- Editing --------------------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.virtualedit = "block"
opt.formatoptions = "jcroqlnt"
opt.confirm = true -- ask instead of failing when quitting with unsaved changes
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share the system clipboard (macOS pbcopy/pbpaste)
opt.completeopt = { "menu", "menuone", "noselect" }
opt.jumpoptions = "view"
opt.spelllang = { "en", "ru" }

-- Files / performance --------------------------------------------------------
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.updatetime = 200
opt.timeoutlen = 300
opt.autoread = true
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Folding: treesitter-based, everything open by default.
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""

-- Markdown / Obsidian wiki links need conceal.
opt.conceallevel = 2

-- Silence :checkhealth warnings for providers we don't use.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Netrw is replaced by neo-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
