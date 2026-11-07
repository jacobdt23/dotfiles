# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"

# Set name of the theme to load.
# Common great options: "font", "powerline", "agnoster", "pure"
OSH_THEME="font"

# Plugins to load
# e.g. plugins=(git bashmarks colored-man-pages)
plugins=(
  git
  bashmarks
  colored-man-pages
)

# Aliases to load
aliases=(
  general
)

# Load Oh My Bash
source "$OSH/oh-my-bash.sh"

# User Aliases & Environment
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

[ -f "$HOME/.config/gemini/api_key" ] && export GEMINI_API_KEY="$(cat "$HOME/.config/gemini/api_key" 2>/dev/null)"
