source /usr/local/share/examples/fzf/shell/key-bindings.bash
source /usr/local/share/examples/fzf/shell/completion.bash

for ALIAS in ~/.alias/*
do
	source "$ALIAS"
done

PROMPT_COMMAND="source ~/.bashprompt"
