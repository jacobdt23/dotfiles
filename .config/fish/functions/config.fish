function config --wraps='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME' --wraps='/usr/bin/git --git-dir=/home/jacob/.cfg/ --work-tree=/home/jacob' --wraps='/usr/bin/git --git-dir=/home/jacob/dotfiles/ --work-tree=/home/jacob' --description 'alias config=/usr/bin/git --git-dir=/home/jacob/dotfiles/ --work-tree=/home/jacob'
    /usr/bin/git --git-dir=/home/jacob/dotfiles/ --work-tree=/home/jacob $argv
end
