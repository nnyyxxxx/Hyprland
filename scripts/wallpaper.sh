#!/bin/sh

config_file="$HOME/hyprland/extra/hyprwall/config.ini"
last_value=""

while true; do
    inotifywait -e modify "$config_file" >/dev/null 2>&1
    current_value=$(grep "last_wallpaper" "$config_file" | cut -d'=' -f2 | tr -d ' ')
    if [ "$current_value" != "$last_value" ] && [ -n "$current_value" ]; then
        wal -i "$(echo "$current_value" | sed "s|^~|$HOME|")"
        killall waybar; waybar &
        pywalfox update
        background=$(jq -r '.special.background' ~/.cache/wal/colors.json | sed 's/#//')
        echo "\$background = rgba(${background}FF)" > ~/.cache/wal/colors-hyprland.conf
        mkdir -p "$HOME/.config/vesktop/themes"
        cp ~/.cache/wal/discord-pywal.css "$HOME/.config/vesktop/themes/pywal.css"
        
        if [ ! -w /opt/spotify ] || [ ! -w /opt/spotify/Apps ]; then
            pkexec chmod a+wr /opt/spotify
            pkexec chmod a+wr /opt/spotify/Apps -R
        fi

        mkdir -p ~/.config/spotify
        touch ~/.config/spotify/prefs
        
        color0=$(sed -n '1p' ~/.cache/wal/colors | sed 's/#//g')
        color1=$(sed -n '2p' ~/.cache/wal/colors | sed 's/#//g')
        color2=$(sed -n '3p' ~/.cache/wal/colors | sed 's/#//g')
        color3=$(sed -n '4p' ~/.cache/wal/colors | sed 's/#//g')
        color4=$(sed -n '5p' ~/.cache/wal/colors | sed 's/#//g')
        color5=$(sed -n '6p' ~/.cache/wal/colors | sed 's/#//g')
        color6=$(sed -n '7p' ~/.cache/wal/colors | sed 's/#//g')
        color7=$(sed -n '8p' ~/.cache/wal/colors | sed 's/#//g')
        
        find $HOME/hyprland/extra/gtk-3.0/dark-horizon/gtk-3.0/ -name "*.css" -exec sed -i 's/background-color: #[0-9a-fA-F]\+;*/background-color: #'"${color0}"';/g' {} \;
        
        find $HOME/hyprland/extra/gtk-3.0/dark-horizon/gtk-4.0/ -name "*.css" -exec sed -i 's/background-color: #[0-9a-fA-F]\+;*/background-color: #'"${color0}"';/g' {} \;

        gsettings set org.gnome.desktop.interface gtk-theme "dummy"
        gsettings set org.gnome.desktop.interface gtk-theme "dark-horizon"

        cat > $HOME/hyprland/extra/dunst/dunstrc << EOF
[global]
    width = 300
    height = 100
    offset = 6x6
    padding = 16
    horizontal_padding = 16
    frame_width = 1
    frame_color = "#${color2}"
    separator_color = "#${color2}"
    font = JetBrainsMono Nerd Font 10
    line_height = 4
    corner_radius = 5
    origin = top-right

    background = "#${color0}"
    foreground = "#${color7}"

    timeout = 5
    idle_threshold = 120

[urgency_low]
    background = "#${color0}"
    foreground = "#${color7}"
    timeout = 5

[urgency_normal]
    background = "#${color0}"
    foreground = "#${color7}"
    timeout = 5

[urgency_critical]
    background = "#${color0}"
    foreground = "#${color1}"
    timeout = 0
EOF

        pkill dunst; dunst &

        cat > ~/.config/spicetify/Themes/Sleek/color.ini << EOF
[Pywal]
text               = ${color7}
subtext            = ${color7}
sidebar-text       = ${color7}
main              = ${color0}
sidebar           = ${color0}
player            = ${color0}
card              = ${color0}
shadow            = ${color0}
selected-row      = ${color3}
button            = ${color4}
button-active     = ${color4}
button-disabled   = ${color7}
tab-active        = ${color4}
notification      = ${color6}
notification-error = ${color1}
misc              = ${color2}
EOF

        /home/$USER/.spicetify/spicetify backup apply
        /home/$USER/.spicetify/spicetify config current_theme Sleek
        /home/$USER/.spicetify/spicetify config color_scheme Pywal
        /home/$USER/.spicetify/spicetify apply

        if pgrep -x spotify > /dev/null && pgrep -x spicetify > /dev/null; then
            pkill -x spicetify
            /home/$USER/.spicetify/spicetify -q watch -s &
        fi
        
        if ! grep -q "\[color\]" "$HOME/hyprland/extra/cava/config"; then
            printf "\n[color]\nbackground = '#%s'\ngradient = 1\n" "$color0" >> "$HOME/hyprland/extra/cava/config"
            i=1
            while [ $i -le 8 ]; do
                eval "current_color=\$color$((8-i))"
                printf "gradient_color_%d = '#%s'\n" "$i" "$current_color" >> "$HOME/hyprland/extra/cava/config"
                i=$((i + 1))
            done
        else
            color_section=$(cat << EOF
[color]
background = '#${color0}'
gradient = 1

gradient_color_1 = '#${color7}'
gradient_color_2 = '#${color6}'
gradient_color_3 = '#${color5}'
gradient_color_4 = '#${color4}'
gradient_color_5 = '#${color3}'
gradient_color_6 = '#${color2}'
gradient_color_7 = '#${color1}'
gradient_color_8 = '#${color0}'

EOF
)
            awk -v colors="$color_section" '
                /\[color\]/ { print colors; skip = 1; next }
                /^\[/ { skip = 0 }
                !skip { print }
            ' "$HOME/hyprland/extra/cava/config" > "$HOME/hyprland/extra/cava/config.tmp" && 
            mv "$HOME/hyprland/extra/cava/config.tmp" "$HOME/hyprland/extra/cava/config"
        fi

        pkill cava; cava &

        last_value="$current_value"
    fi
done