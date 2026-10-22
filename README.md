# dotfiles

Каждая папка — это конфиг из `~/.config/<app>`.

```sh
git clone <repo> ~/.dotfiles
cd ~/.dotfiles && stow .
brew bundle            # пакеты и приложения из Brewfile
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv
```

`windows/` на macOS игнорируется (см. `.stowrc`).

superfile на macOS читает конфиг из `~/Library/Application Support/superfile`, поэтому после `stow` нужен симлинк:

```sh
ln -sf ~/.config/superfile/config.toml ~/Library/Application\ Support/superfile/config.toml
```

Karabiner перезаписывает `karabiner.json` целиком, поэтому линкуется вся папка (из stow она исключена):

```sh
ln -s ../.dotfiles/karabiner ~/.config/karabiner
```

Obsidian (плагин Vimrc Support) читает `.obsidian.vimrc` из корня vault, поэтому папка исключена из stow и линкуется в каждый vault:

```sh
ln -s ~/.dotfiles/obsidian/.obsidian.vimrc <vault>/.obsidian.vimrc
```
