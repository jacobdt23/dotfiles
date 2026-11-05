fish_add_path -a $HOME/.local/bin

if status is-interactive
    # Disable default greeting
    set -g fish_greeting ""

    # Aliases
    alias v="nvim"
    alias nv="neovide"
    alias gs="git status"
    alias ll="ls -lah"
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    # Package management
    alias pkg-save='~/.local/bin/pkg-save'
    alias pkg-list='~/.local/bin/pkg-save --list'
    alias pkg-install='~/.local/bin/pkg-install'
    alias paru-clean='paru -Sc'

    # Fastfetch system info on startup
    if type -q fastfetch
        fastfetch
    end
end
if test -f ~/.config/gemini/api_key
    set -gx GEMINI_API_KEY (cat ~/.config/gemini/api_key | string trim)
end
