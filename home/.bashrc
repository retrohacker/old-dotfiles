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
PROMPT_COMMAND="source ~/.bashprompt"
