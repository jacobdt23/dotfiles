if status is-interactive
    # Disable default greeting
    set -g fish_greeting ""

    # Aliases
    alias v="nvim"
    alias vim="nvim"
    alias nv="neovide"
    alias gs="git status"
    alias ll="ls -lah"
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    # Fastfetch system info on startup
    if type -q fastfetch
        fastfetch
    end
end
