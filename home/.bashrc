source /usr/local/share/examples/fzf/shell/key-bindings.bash
source /usr/local/share/examples/fzf/shell/completion.bash

for SOURCE in ~/.source/*
do
	source "$SOURCE"
done

if [[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]]
then
	source /usr/local/share/bash-completion/bash_completion.sh
fi

PROMPT_COMMAND="source ~/.bashprompt"
