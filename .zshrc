# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format '%F{magenta}Completing %d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/fading/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -v
# End of lines configured by zsh-newuser-install

# aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"

autoload -Uz promptinit
promptinit
# prompt suse

# TODO custom prompt with retval, vimode, user, hostname, (full) path, git stuff and colors
# function vimode {
# 	VIMODE="${${KEYMAP/vicmd/-N-}/(main|viins)/-I-}"
# 	zle reset-prompt
# }
# zle -N vimode

zle-keymap-select () {
	case $KEYMAP in
		visual) VIMODE="-V-";;
		(viins|main)) VIMODE="-I-";;
		vicmd) VIMODE="-N-";;
	esac

	zle reset-prompt
}

zle -N zle-keymap-select

function precmd() {
	RETVAL=$?
	VIMODE="-I-"

	# TODO this only works if in the git directory; not in any child directories
	if [ -d .git ]; then
		GITBRANCH=`git branch -v | sed -E "s/\* ([^ ]*) .*/\1/g"`
	else
		GITBRANCH=''
	fi;

	if [ $RETVAL = 0 ]; then
		RETVAL_STR=""
	else
		RETVAL_STR="%F{red}(${RETVAL})%f"
	fi
}

setprompt () {
	setopt prompt_subst

	PROMPT='${RETVAL_STR}[%F{cyan}%n%f@%m : %(4~|.../%3~|%~) %F{red}${GITBRANCH}%f][${VIMODE}] $ '
}

setprompt
ications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
