PATH="$PATH:~/.bin:~/go/bin"
for SOURCE in ~/.source/*
do
	source "$SOURCE"
done

source ~/.config/fzf/key-bindings.bash
source /usr/local/share/examples/fzf/shell/completion.bash

if [[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]]
then
	source /usr/local/share/bash-completion/bash_completion.sh
fi

PROMPT_COMMAND="source ~/.bashprompt"
