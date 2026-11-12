#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment & PATH
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$PATH:$HOME/.local/bin"
[ -f "$HOME/.config/gemini/api_key" ] && export GEMINI_API_KEY="$(cat "$HOME/.config/gemini/api_key" 2>/dev/null)"

# System completion on-demand loader
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

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export EDITOR='nvim'
export VISUAL='nvim'
alias ll='ls -lah --color=auto'
alias gs='git status'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Package management helpers
alias pkg-save='~/.local/bin/pkg-save'
alias pkg-list='~/.local/bin/pkg-save --list'
alias pkg-install='~/.local/bin/pkg-install'
alias paru-clean='paru -Sc'

# Clean colored prompt with Git branch integration
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=1
  PROMPT_COMMAND='__git_ps1 "\[\e[1;36m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]" "\n\[\e[1;32m\]❯\[\e[0m\] "'
else
  PS1='\[\e[1;36m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;32m\]❯\[\e[0m\] '
fi

# Launch fastfetch
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
