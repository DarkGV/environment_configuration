[ -z "$PLUGINS" ] && PLUGINS=$(ls ~/.zsh//plugins)

plugins=()
for plugin in $PLUGINS; do
    plugins+=($(ls ~/.oh-my-zsh | grep -m1 -w $plugin));
done