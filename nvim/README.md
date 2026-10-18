# Neovim config: web dev + Git + Docker + Obsidian

Requires **Neovim 0.11+** (written and tested against 0.12.6). Plugin manager: lazy.nvim.
Leader key is `<Space>`; press it and wait, which-key shows every available mapping.

## 1. Install

```sh
# 1. back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null

# 2. copy this folder to ~/.config/nvim
cp -R nvim ~/.config/nvim

# 3. system dependencies (macOS / Homebrew)
brew install neovim git ripgrep fd lazygit lazydocker tree-sitter-cli pngpaste
brew install php composer      # only for host-side PHP tooling (phpcs, php-cs-fixer); see section 4

# 4. start Neovim from a terminal where fnm is active (Mason installs servers via npm)
nvim
```

On first launch lazy.nvim installs plugins, then Mason installs LSP servers/tools and
nvim-treesitter compiles parsers (needs the Xcode Command Line Tools and `tree-sitter-cli`).
Give it a minute, then restart Neovim. Run `:checkhealth` if something looks off.

Notes:
- Use a [Nerd Font](https://www.nerdfonts.com/) in your terminal (you already have one).
- Alt-based mappings (`<A-j>` / `<A-k>` move lines) need "Use Option as Meta key" in your terminal.
- Start `nvim` from a shell, not from a GUI launcher, so `node` from fnm is on `PATH`.
- `docker`, `lazygit`, `lazydocker` and `claude` (Claude Code CLI) must be on `PATH` as well.

## 2. Things you need to edit

| What | Where |
|---|---|
| Obsidian vault path (currently a placeholder) | `export OBSIDIAN_VAULT="$HOME/path/to/vault"` in `~/.zshrc`, **or** edit `vault_path` at the top of `lua/plugins/obsidian.lua` |
| Daily notes / templates folder names | `daily_notes.folder` ("Daily") and `templates.folder` ("Templates") in `lua/plugins/obsidian.lua` |
| Intelephense premium licence (optional) | `export INTELEPHENSE_LICENCE_KEY=...` |
| Claude Code binary, if `claude` is not found | `terminal_cmd` in `lua/plugins/ai.lua` |
| Colorscheme | `lua/plugins/ui.lua` (tokyonight; `<leader>uC` previews others) |

## 3. Layout

```
init.lua                  entry point
lua/config/               options, keymaps, autocmds, filetypes, lazy.nvim bootstrap
lua/plugins/
  ui.lua                  theme, statusline, bufferline, which-key
  treesitter.lua          syntax parsers (php, twig, html, css, scss, js, ts, ...)
  lsp.lua                 Mason + native vim.lsp.config for every language server
  completion.lua          blink.cmp, autopairs
  formatting.lua          conform (prettier, phpcbf, php-cs-fixer, stylua) + nvim-lint (phpcs, hadolint)
  snacks.lua              pickers, lazygit, terminal, notifications, dashboard
  explorer.lua            neo-tree (classic file tree)
  git.lua                 gitsigns, diffview
  editor.lua              surround, flash, todo-comments, trouble, sessions
  docker.lua              lazydocker + docker compose helpers
  tasks.lua               overseer (run npm / composer / make tasks)
  obsidian.lua            obsidian.nvim + render-markdown.nvim
  debug.lua               nvim-dap (PHP + Xdebug), neotest (PHPUnit)
  ai.lua                  Claude Code integration
```

## 4. Per-project setup (WordPress / Drupal / Docker)

**PHP code style.** Formatting and linting only run for PHP when the project declares a standard,
so core and vendor code is never reformatted by surprise:
- `phpcs.xml` / `phpcs.xml.dist` / `.phpcs.xml` in the project root → `phpcs` lints, `phpcbf` formats on save.
- `.php-cs-fixer.php` / `.php-cs-fixer.dist.php` → `php-cs-fixer` formats on save.
- The project's own `vendor/bin/phpcs|phpcbf|php-cs-fixer` is preferred over the Mason one, so install
  WPCS or Drupal Coder through composer in the project (`composer require --dev wp-coding-standards/wpcs`
  or `drupal/coder`). These binaries run on the **host**, so you need `php` locally (`brew install php`).
  If you don't want PHP on the host, format via Docker: `<leader>Dc` → `php vendor/bin/phpcbf path/to/file.php`.
- Toggle format-on-save with `<leader>uf` (`:FormatDisable!` for the current buffer only).

**JS / CSS.** ESLint and Stylelint run as language servers and use the project's own config and
`node_modules`. Prettier uses the project's `.prettierrc` / `.editorconfig`.

**Twig and Nunjucks.** Twig has a parser and the Twiggy language server. Nunjucks (`.njk`) has no
parser or server; it is opened as `htmldjango`, which gives decent `{% %}` / `{{ }}` highlighting plus
HTML and Emmet completion. Twig/Nunjucks files are not auto-formatted.

**Per-project overrides.** `exrc` is on: put a `.nvim.lua` in a project root and Neovim will ask
once whether to trust it. Useful for Docker/Xdebug settings:

```lua
-- .nvim.lua
vim.g.php_debug_remote_root = "/var/www/html/web"  -- container path that maps to the project root
vim.g.docker_default_service = "php"               -- default service for <leader>Ds
```

**Debugging PHP in Docker (Xdebug 3).** In the container's php.ini:

```ini
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
```

Then: `<leader>db` set a breakpoint → `<leader>dc` start listening → open the site with the Xdebug
trigger (browser extension "Xdebug helper"). The default path mapping is `/var/www/html` → project root.

## 5. Cheat sheet (the important ones)

| Keys | Action |
|---|---|
| `<leader><space>` / `<leader>/` | find files / grep in project |
| `<leader>e` / `<leader>E` | file tree toggle / reveal current file |
| `<leader>,` | switch buffer; `S-h` / `S-l` previous / next buffer |
| `gd` `gr` `gI` `K` | definition, references, implementation, hover |
| `<leader>ca` `<leader>cr` `<leader>cf` | code action, rename, format |
| `]d` `[d` `<leader>cd` `<leader>xx` | next / prev diagnostic, line diagnostic, diagnostics list |
| `s` / `S` | flash jump / flash by treesitter node |
| `gsa` `gsd` `gsr` | add / delete / replace surround |
| `<C-/>` | toggle terminal |
| `<leader>gg` | lazygit |
| `<leader>gd` `<leader>gH` | diffview (working tree) / file history |
| `]h` `[h` `<leader>hs` `<leader>hr` `<leader>hp` | next / prev hunk, stage, reset, preview |
| `<leader>Dd` | lazydocker |
| `<leader>Du` `<leader>DD` `<leader>Dl` `<leader>Dp` | compose up / down / logs / ps |
| `<leader>Ds` / `<leader>Dc` | shell in a service / run a command in a service |
| `<leader>rr` | run an npm / composer / make task |
| `<leader>on` `<leader>oo` `<leader>os` | Obsidian: new note, open note, search |
| `<leader>ot` `<leader>ob` `<leader>oT` | Obsidian: today's daily note, backlinks, insert template |
| `<CR>` on a `[[link]]` | follow the link (also toggles checkboxes) |
| `<leader>ac` | Claude Code side panel (`<leader>as` sends the selection) |
| `<leader>aa` / `<leader>ad` | accept / deny a diff proposed by Claude |
| `<leader>db` `<leader>dc` `<leader>do` `<leader>di` | breakpoint, continue, step over, step into |
| `<leader>tt` `<leader>tr` | run test file / nearest test (PHPUnit, on the host) |
| `<leader>qs` | restore the session for the current directory |

`<leader>sk` searches all keymaps. `:Lazy` manages plugins, `:Mason` manages servers and tools.

## 6. Known limits

- Treesitter parsers and Mason packages are downloaded on first launch; they need internet access.
- PHPUnit tests (`<leader>t*`) run on the host. For tests that must run inside a container use `<leader>Dc`.
- Image previews in Markdown are off (`image.enabled = false` in `snacks.lua`); enable it only if
  your terminal supports the Kitty graphics protocol (Ghostty, Kitty, WezTerm).
- `:Obsidian paste_img` needs `pngpaste` on macOS (installed in step 1).
- Not included: a REST/HTTP client, twig-cs-fixer/twigcs, a Nunjucks formatter.
