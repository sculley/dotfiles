#
# .zshrc
#
# @author Sam Culley
#

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

## Custom $PATH with extra locations.
# Homebrew
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

# golang
export PATH=$HOME/Go/bin:$PATH

# python
export PATH=$HOME/Library/Python/3.9/bin:$PATH

# local/system bin paths
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:$PATH

# https://github.com/ohmyzsh/ohmyzsh/issues/10385
# Removes the warning in shell when loading pyenv as plugin.
export ZSH_PYENV_QUIET=true

# https://github.com/pyenv/pyenv-virtualenv/issues/135
# Removes the warning in shell when loading pyenv-virtualenv as plugin.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Enable plugins.
plugins=(aws ansible git brew history helm kubectl kubectx history-substring-search pyenv terraform)

source $ZSH/oh-my-zsh.sh

# iterm2-shell-ingegration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for various tasks.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Include functios file (if present) containing functions for various tasks.
if [ -f ~/.functions ]
then
  source ~/.functions
fi

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Allow history search via up/down keys.
if [[ ! -f ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh ]]
then
  source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey "^[[A" history-substring-search-up
  bindkey "^[[B" history-substring-search-down
fi

# Completions.
# brew (must be run before compinit)
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit && compinit

# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# aws
if command -v /opt/homebrew/bin/aws_completer &> /dev/null
then
  complete -C '/opt/homebrew/bin/aws_completer' aws
fi

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

if command -v pyenv &> /dev/null
then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# go
export GOPATH=$HOME/Go
export GOROOT=/opt/homebrew/opt/go/libexec

# kubectl krew
export PATH="${PATH}:${HOME}/.krew/bin"

# AWS
if [ -f ~/.aws/credentials ]
then
  export AWS_PROFILE=default
  export AWS_REGION=eu-west-2
fi

# powerlevel10k
[[ ! -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] || source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh