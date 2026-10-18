# dotfiles

Каждая папка — это конфиг из `~/.config/<app>`.

```sh
git clone <repo> ~/.dotfiles
cd ~/.dotfiles && stow .
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv
```

`windows/` на macOS игнорируется (см. `.stowrc`).

superfile на macOS читает конфиг из `~/Library/Application Support/superfile`, поэтому после `stow` нужен симлинк:

```sh
ln -sf ~/.config/superfile/config.toml ~/Library/Application\ Support/superfile/config.toml
```
