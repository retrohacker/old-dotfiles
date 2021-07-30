PATH="$PATH:~/.bin:~/go/bin"
for SOURCE in ~/.source/*
do
	source "$SOURCE"
done

source ~/.config/fzf/key-bindings.bash
source ~/.config/fzf/completion.bash

if [[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]]
then
	source /usr/local/share/bash-completion/bash_completion.sh
fi

alias ls="ls --color"

function git() {
    if [[ "$1" == "diff" ]]
    then
        shift
        git difftool --extcmd='icdiff -N -L "$REMOTE" -L ""' -y "$@" | less -R
    else
        command git "$@"
    fi
}

export EDITOR="kak"

PROMPT_COMMAND="source ~/.bashprompt"
