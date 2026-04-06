# dotfiles

I like a lot of [this blog post](https://www.josean.com/posts/terminal-setup) for my OOB setup.

Set up git:

```
git config --global user.email "ethanlookpotts@gmail.com"
git config --global user.name "Ethan Look-Potts"
```

[Add a public key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to Github.

Clone this repo and link dotfiles:

```
git clone git@github.com:ethanlookpotts/dotfiles.git
```

Follow [this blog](https://www.josean.com/posts/terminal-setup) to install most of the things you like. Then:

```
brew install tmux
brew install thefuck
brew install neovim
brew install ripgrep
brew install fzf
brew install watch
ln -s ~/src/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/src/dotfiles/.zshrc ~/.zshrc
ln -s ~/src/dotfiles/.config/nvim ~/.config/nvim
```

### Private Configuration

For machine-specific settings (credentials, etc.), create `~/.zshrc.local`.

iTerm color theme: https://github.com/bluz71/vim-moonfly-colors/blob/master/extras/moonfly.itermcolors
