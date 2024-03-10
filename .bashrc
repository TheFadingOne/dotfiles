IFS= 

retval() {
        if [ $? -eq 0 ]; then
                printf ""
        else
                printf "\001\e[31m\002($?)\001\e[0m\002"
        fi
}

gitbranch() {
        if type git 2> /dev/null 1> /dev/null && git rev-parse 2> /dev/null 1> /dev/null ; then
                MODIFIED=""
                if [[ -n $(git status --short) ]]; then
                        MODIFIED=" M"
                fi
                BRANCH=$(git rev-parse --abbrev-ref HEAD)
                SHORTREF=$(git rev-parse --short HEAD)
                printf "\001\e[31m\002%s\001\e[0m\002(%s)\001\e[31m\002%s\001\e[0m\002" $BRANCH $SHORTREF $MODIFIED
        else
                echo -n ""
        fi
}

alias ls='ls --color=auto'

export PROMPT_DIRTRIM=3

PS1='$(retval)[\001\e[1;95m\002\u\001\e[0m\002@\h : \w $(gitbranch)] \$ '
PS2='> '
