# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"

# Set name of the theme to load.
# Common great options: "font", "powerline", "agnoster", "pure"
OSH_THEME="powerline"

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

# Completions to load
completions=(
  git
  ssh
  system
  dirs
  tmux
)

# Load Oh My Bash
source "$OSH/oh-my-bash.sh"

# Dynamic system completion loader (enables instant on-demand Tab completion for system tools)
if ! type _completion_loader >/dev/null 2>&1; then
  _lazy_completion_loader() {
    local comp_path="/usr/share/bash-completion/completions/$1"
    if [[ -f "$comp_path" ]]; then
      . "$comp_path" && return 124
    fi
    return 1
  }
  complete -D -F _lazy_completion_loader 2>/dev/null || true
fi

# User Aliases & Environment
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

[ -f "$HOME/.config/gemini/api_key" ] && export GEMINI_API_KEY="$(cat "$HOME/.config/gemini/api_key" 2>/dev/null)"
fastfetch
