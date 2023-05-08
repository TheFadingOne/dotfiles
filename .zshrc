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
bindkey -e
# End of lines configured by zsh-newuser-install

# aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"

function precmd() {
	RETVAL=$?
	GITBRANCH=''
	GITINFO=''

	if type git 2> /dev/null 1> /dev/null && git rev-parse 2> /dev/null 1> /dev/null ; then
		GITBRANCH="$(git rev-parse --abbrev-ref HEAD)($(git rev-parse --short HEAD))"

		if [[ -n $(git status --short) ]]; then
                        GITINFO="*"
                fi
	fi

	if [ $RETVAL = 0 ]; then
		RETVAL_STR=""
	else
		RETVAL_STR="%F{red}(${RETVAL})%f"
	fi
}

setprompt () {
	setopt prompt_subst

	PROMPT='${RETVAL_STR}[%F{cyan}%n%f@%m : %(4~|.../%3~|%~) %F{red}${GITBRANCH}%f${GITINFO}] $ '
}

setprompt
