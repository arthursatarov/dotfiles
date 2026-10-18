# dotfiles

Каждая папка — это конфиг из `~/.config/<app>`.

```sh
git clone <repo> ~/.dotfiles
cd ~/.dotfiles && stow .
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv
```

`windows/` на macOS игнорируется (см. `.stowrc`).
