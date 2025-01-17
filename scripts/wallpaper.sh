#!/bin/sh

config_dir="$HOME/dotfiles/extra/waypaper"
config_file="$config_dir/config.ini"
last_value=""

inotifywait -m -e modify,create "$config_dir" | while read -r directory events filename; do
    if [ "$filename" = "config.ini" ]; then
        current_value=$(grep "^wallpaper = " "$config_file" | cut -d'=' -f2 | tr -d ' ')
        if [ "$current_value" != "$last_value" ] && [ -n "$current_value" ]; then
            wallpaper_path=$(echo "$current_value" | sed "s|^~|$HOME|")
            wal -i "$wallpaper_path"
            killall -q waybar
            waybar &
            pywalfox update
            background=$(jq -r '.colors.color2' $HOME/.cache/wal/colors.json | sed 's/#//')
            echo "\$background = rgba(${background}FF)" >$HOME/.cache/wal/colors-dotfiles.conf
            mkdir -p "$HOME/.config/vesktop/themes"
            cp "$HOME/.cache/wal/discord-pywal.css" "$HOME/.config/vesktop/themes/pywal.css"
            cp "$wallpaper_path" "$HOME/.cache/wal/current_wallpaper"

            color0=$(sed -n '1p' $HOME/.cache/wal/colors | sed 's/#//g')
            color1=$(sed -n '2p' $HOME/.cache/wal/colors | sed 's/#//g')
            color2=$(sed -n '3p' $HOME/.cache/wal/colors | sed 's/#//g')
            color3=$(sed -n '4p' $HOME/.cache/wal/colors | sed 's/#//g')
            color4=$(sed -n '5p' $HOME/.cache/wal/colors | sed 's/#//g')
            color5=$(sed -n '6p' $HOME/.cache/wal/colors | sed 's/#//g')
            color6=$(sed -n '7p' $HOME/.cache/wal/colors | sed 's/#//g')
            color7=$(sed -n '8p' $HOME/.cache/wal/colors | sed 's/#//g')

            find $HOME/dotfiles/extra/gtk-3.0/dark-horizon/gtk-3.0/ -name "*.css" -exec sed -i \
                -e "s/background-color: #[0-9a-fA-F]\+;/background-color: #${color0};/g" \
                -e "s/-gtk-secondary-caret-color: #[0-9a-fA-F]\+;/-gtk-secondary-caret-color: #${color4};/g" \
                -e "s/border: 1px solid #[0-9a-fA-F]\+;/border: 1px solid #${color2};/g" \
                -e "s/border-color: #[0-9a-fA-F]\+;/border-color: #${color2};/g" \
                -e "s/box-shadow: inset 0 0 0 [0-9]\+px #[0-9a-fA-F]\+;/box-shadow: inset 0 0 0 2px #${color2};/g" \
                -e "s/outline-color: #[0-9a-fA-F]\+;/outline-color: #${color2};/g" \
                -e "s/background-image: radial-gradient(circle, #[0-9a-fA-F]\+ /background-image: radial-gradient(circle, #${color4} /g" \
                -e "s/background-image: -gtk-gradient(radial, center center, 0, center center, 0.001, to(#[0-9a-fA-F]\+)/background-image: -gtk-gradient(radial, center center, 0, center center, 0.001, to(#${color4})/g" \
                -e "s/caret-color: #[0-9a-fA-F]\+;/caret-color: #${color4};/g" \
                -e "s/border-bottom: 2px solid #[0-9a-fA-F]\+;/border-bottom: 2px solid #${color2};/g" \
                -e "s/border-top: 2px solid #[0-9a-fA-F]\+;/border-top: 2px solid #${color2};/g" \
                -e "s/border-left: 2px solid #[0-9a-fA-F]\+;/border-left: 2px solid #${color2};/g" \
                -e "s/border-right: 2px solid #[0-9a-fA-F]\+;/border-right: 2px solid #${color2};/g" \
                -e "s/box-shadow: 0 0 0 1px #[0-9a-fA-F]\+;/box-shadow: 0 0 0 1px #${color2};/g" \
                -e "s/text-shadow: 0 1px #[0-9a-fA-F]\+;/text-shadow: 0 1px #${color0};/g" \
                -e "s/@define-color theme_bg_color #[0-9a-fA-F]\+;/@define-color theme_bg_color #${color0};/g" \
                -e "s/@define-color theme_fg_color #[0-9a-fA-F]\+;/@define-color theme_fg_color #${color7};/g" \
                -e "s/@define-color theme_text_color #[0-9a-fA-F]\+;/@define-color theme_text_color #${color7};/g" \
                -e "s/@define-color theme_selected_bg_color #[0-9a-fA-F]\+;/@define-color theme_selected_bg_color #${color2};/g" \
                -e "s/@define-color theme_selected_fg_color #[0-9a-fA-F]\+;/@define-color theme_selected_fg_color #${color7};/g" \
                -e "s/@define-color accent_bg_color #[0-9a-fA-F]\+;/@define-color accent_bg_color #${color4};/g" \
                -e "s/@define-color accent_fg_color #[0-9a-fA-F]\+;/@define-color accent_fg_color #${color7};/g" \
                -e "s/@define-color accent_color #[0-9a-fA-F]\+;/@define-color accent_color #${color4};/g" \
                -e "s/@define-color destructive_color #[0-9a-fA-F]\+;/@define-color destructive_color #${color1};/g" \
                -e "s/@define-color success_color #[0-9a-fA-F]\+;/@define-color success_color #${color2};/g" \
                -e "s/@define-color warning_color #[0-9a-fA-F]\+;/@define-color warning_color #${color3};/g" \
                -e "s/@define-color error_color #[0-9a-fA-F]\+;/@define-color error_color #${color1};/g" \
                -e "s/@define-color window_bg_color #[0-9a-fA-F]\+;/@define-color window_bg_color #${color0};/g" \
                -e "s/@define-color window_fg_color #[0-9a-fA-F]\+;/@define-color window_fg_color #${color7};/g" \
                -e "s/@define-color view_bg_color #[0-9a-fA-F]\+;/@define-color view_bg_color #${color0};/g" \
                -e "s/@define-color view_fg_color #[0-9a-fA-F]\+;/@define-color view_fg_color #${color7};/g" \
                -e "s/@define-color headerbar_bg_color #[0-9a-fA-F]\+;/@define-color headerbar_bg_color #${color0};/g" \
                -e "s/@define-color headerbar_fg_color #[0-9a-fA-F]\+;/@define-color headerbar_fg_color #${color7};/g" \
                {} \;

            find $HOME/dotfiles/extra/gtk-3.0/dark-horizon/gtk-4.0/ -name "*.css" -exec sed -i \
                -e "s/background-color: #[0-9a-fA-F]\+;/background-color: #${color0};/g" \
                -e "s/-gtk-secondary-caret-color: #[0-9a-fA-F]\+;/-gtk-secondary-caret-color: #${color4};/g" \
                -e "s/border: 1px solid #[0-9a-fA-F]\+;/border: 1px solid #${color2};/g" \
                -e "s/border-color: #[0-9a-fA-F]\+;/border-color: #${color2};/g" \
                -e "s/box-shadow: inset 0 0 0 [0-9]\+px #[0-9a-fA-F]\+;/box-shadow: inset 0 0 0 2px #${color2};/g" \
                -e "s/outline-color: #[0-9a-fA-F]\+;/outline-color: #${color2};/g" \
                -e "s/background-image: radial-gradient(circle, #[0-9a-fA-F]\+ /background-image: radial-gradient(circle, #${color4} /g" \
                -e "s/background-image: -gtk-gradient(radial, center center, 0, center center, 0.001, to(#[0-9a-fA-F]\+)/background-image: -gtk-gradient(radial, center center, 0, center center, 0.001, to(#${color4})/g" \
                -e "s/caret-color: #[0-9a-fA-F]\+;/caret-color: #${color4};/g" \
                -e "s/border-bottom: 2px solid #[0-9a-fA-F]\+;/border-bottom: 2px solid #${color2};/g" \
                -e "s/border-top: 2px solid #[0-9a-fA-F]\+;/border-top: 2px solid #${color2};/g" \
                -e "s/border-left: 2px solid #[0-9a-fA-F]\+;/border-left: 2px solid #${color2};/g" \
                -e "s/border-right: 2px solid #[0-9a-fA-F]\+;/border-right: 2px solid #${color2};/g" \
                -e "s/box-shadow: 0 0 0 1px #[0-9a-fA-F]\+;/box-shadow: 0 0 0 1px #${color2};/g" \
                -e "s/text-shadow: 0 1px #[0-9a-fA-F]\+;/text-shadow: 0 1px #${color0};/g" \
                -e "s/@define-color theme_bg_color #[0-9a-fA-F]\+;/@define-color theme_bg_color #${color0};/g" \
                -e "s/@define-color theme_fg_color #[0-9a-fA-F]\+;/@define-color theme_fg_color #${color7};/g" \
                -e "s/@define-color theme_text_color #[0-9a-fA-F]\+;/@define-color theme_text_color #${color7};/g" \
                -e "s/@define-color theme_selected_bg_color #[0-9a-fA-F]\+;/@define-color theme_selected_bg_color #${color2};/g" \
                -e "s/@define-color theme_selected_fg_color #[0-9a-fA-F]\+;/@define-color theme_selected_fg_color #${color7};/g" \
                -e "s/@define-color accent_bg_color #[0-9a-fA-F]\+;/@define-color accent_bg_color #${color4};/g" \
                -e "s/@define-color accent_fg_color #[0-9a-fA-F]\+;/@define-color accent_fg_color #${color7};/g" \
                -e "s/@define-color accent_color #[0-9a-fA-F]\+;/@define-color accent_color #${color4};/g" \
                -e "s/@define-color destructive_color #[0-9a-fA-F]\+;/@define-color destructive_color #${color1};/g" \
                -e "s/@define-color success_color #[0-9a-fA-F]\+;/@define-color success_color #${color2};/g" \
                -e "s/@define-color warning_color #[0-9a-fA-F]\+;/@define-color warning_color #${color3};/g" \
                -e "s/@define-color error_color #[0-9a-fA-F]\+;/@define-color error_color #${color1};/g" \
                -e "s/@define-color window_bg_color #[0-9a-fA-F]\+;/@define-color window_bg_color #${color0};/g" \
                -e "s/@define-color window_fg_color #[0-9a-fA-F]\+;/@define-color window_fg_color #${color7};/g" \
                -e "s/@define-color view_bg_color #[0-9a-fA-F]\+;/@define-color view_bg_color #${color0};/g" \
                -e "s/@define-color view_fg_color #[0-9a-fA-F]\+;/@define-color view_fg_color #${color7};/g" \
                -e "s/@define-color headerbar_bg_color #[0-9a-fA-F]\+;/@define-color headerbar_bg_color #${color0};/g" \
                -e "s/@define-color headerbar_fg_color #[0-9a-fA-F]\+;/@define-color headerbar_fg_color #${color7};/g" \
                {} \;

            gsettings set org.gnome.desktop.interface gtk-theme "dummy"
            gsettings set org.gnome.desktop.interface gtk-theme "dark-horizon"

            sed -i "s/@base: #[0-9a-fA-F]\+;/@base: #${color0};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@mantle: #[0-9a-fA-F]\+;/@mantle: #${color0};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@crust: #[0-9a-fA-F]\+;/@crust: #${color0};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@rosewater: #[0-9a-fA-F]\+;/@rosewater: #${color1};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@flamingo: #[0-9a-fA-F]\+;/@flamingo: #${color5};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@pink: #[0-9a-fA-F]\+;/@pink: #${color3};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@mauve: #[0-9a-fA-F]\+;/@mauve: #${color4};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@red: #[0-9a-fA-F]\+;/@red: #${color2};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@maroon: #[0-9a-fA-F]\+;/@maroon: #${color6};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@peach: #[0-9a-fA-F]\+;/@peach: #${color7};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@yellow: #[0-9a-fA-F]\+;/@yellow: #${color3};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@green: #[0-9a-fA-F]\+;/@green: #${color7};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@teal: #[0-9a-fA-F]\+;/@teal: #${color4};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@blue: #[0-9a-fA-F]\+;/@blue: #${color5};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@sapphire: #[0-9a-fA-F]\+;/@sapphire: #${color6};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@sky: #[0-9a-fA-F]\+;/@sky: #${color1};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"
            sed -i "s/@lavender: #[0-9a-fA-F]\+;/@lavender: #${color7};/g" "$HOME/dotfiles/extra/librewolf/catppuccin.json"

            cat >$HOME/dotfiles/extra/dunst/dunstrc <<EOF
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
    origin = top-left
    monitor = 1

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

            cat >$HOME/.config/fuzzel/fuzzel.ini <<EOF
[main]
font=JetBrainsMono Nerd Font:size=14
terminal=alacritty
width=35
horizontal-pad=20
vertical-pad=20
inner-pad=10
line-height=25
layer=overlay
icons-enabled=false

[colors]
background=${color0}ff
text=${color7}ff
match=${color7}ff
selection=${color2}ff
selection-text=${color7}ff
border=${color2}ff

[border]
width=2
radius=5

[dmenu]
exit-immediately-if-empty=true
EOF

            pkill dunst
            dunst &

            if ! grep -q "\[color\]" "$HOME/dotfiles/extra/cava/config"; then
                printf "\n[color]\nbackground = '#%s'\ngradient = 1\n" "$color0" >>"$HOME/dotfiles/extra/cava/config"
                i=1
                while [ $i -le 8 ]; do
                    eval "current_color=\$color$((8 - i))"
                    printf "gradient_color_%d = '#%s'\n" "$i" "$current_color" >>"$HOME/dotfiles/extra/cava/config"
                    i=$((i + 1))
                done
            else
                color_section=$(
                    cat <<EOF
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
            ' "$HOME/dotfiles/extra/cava/config" >"$HOME/dotfiles/extra/cava/config.tmp" &&
                    mv "$HOME/dotfiles/extra/cava/config.tmp" "$HOME/dotfiles/extra/cava/config"
            fi

            pkill cava
            cava &

            cat >$HOME/dotfiles/hypr/dark-horizon.conf <<EOF
\$background = rgb(${color0})
\$backgroundAlpha = ${color0}

\$backgroundAlt = rgb(${color0})
\$backgroundAltAlpha = ${color0}

\$foreground = rgb(${color7})
\$foregroundAlpha = ${color7}

\$selected = rgb(${color4})
\$selectedAlpha = ${color4}

\$active = rgb(${color5})
\$activeAlpha = ${color5}

\$urgent = rgb(${color1})
\$urgentAlpha = ${color1}
EOF

            if [ ! -w "/usr/share/sddm/themes/corners/backgrounds" ]; then
                pkexec chmod 777 /usr/share/sddm/themes/corners/backgrounds
            fi

            if [ ! -w "/usr/share/sddm/themes/corners/theme.conf" ]; then
                pkexec chmod 666 /usr/share/sddm/themes/corners/theme.conf
            fi

            cp "$(eval echo "$current_value")" /usr/share/sddm/themes/corners/backgrounds/wallpaper.png
            cat >/tmp/sddm-theme.conf <<EOF
[General]
BgSource="backgrounds/wallpaper.png"
FontFamily="JetBrainsMono Nerd Font"
FontSize=14
Padding=50
Radius=10
Scale=1

UserPictureEnabled=true
UserBorderWidth=1
UserBorderColor="#${color2}"
UserColor="#${color0}"

InputColor="#${color0}"
InputTextColor="#${color7}"
InputBorderWidth=1
InputBorderColor="#${color2}"
UserPlaceholderText="user"
PassPlaceholderText="password"
HidePassword=true

LoginButtonTextColor="#${color0}"
LoginButtonText="Login"
LoginButtonColor="#${color7}"

PopupColor="#${color0}"
PopupActiveColor="#${color7}"
PopupActiveTextColor="#${color0}"

SessionButtonColor="#${color0}"
SessionIconColor="#${color7}"
PowerButtonColor="#${color0}"
PowerIconColor="#${color7}"

DateTimeSpacing=-20

DateColor="#${color7}"
DateSize=36
DateIsBold=false
DateOpacity=1.0
DateFormat="dddd, MMMM d"

TimeColor="#${color7}"
TimeSize=48
TimeIsBold=true
TimeOpacity=1.0
TimeFormat="hh:mm AP"
EOF
            cp /tmp/sddm-theme.conf /usr/share/sddm/themes/corners/theme.conf
            rm /tmp/sddm-theme.conf

            cat >$HOME/dotfiles/extra/qt5ct/colors/mocha.conf <<EOF
[ColorScheme]
active_colors=#ff${color7}, #ff${color0}, #ff${color2}, #ff${color3}, #ff${color4}, #ff${color5}, #ff${color7}, #ff${color7}, #ff${color7}, #ff${color0}, #ff${color0}, #ff${color2}, #ff${color4}, #ff${color0}, #ff${color4}, #ff${color1}, #ff${color0}, #ff${color7}, #ff${color0}, #ff${color7}, #80${color2}
disabled_colors=#ff${color2}, #ff${color0}, #ff${color2}, #ff${color3}, #ff${color4}, #ff${color5}, #ff${color2}, #ff${color2}, #ff${color2}, #ff${color0}, #ff${color0}, #ff${color2}, #ff${color4}, #ff${color4}, #ff${color4}, #ff${color1}, #ff${color0}, #ff${color7}, #ff${color0}, #ff${color7}, #80${color2}
inactive_colors=#ff${color7}, #ff${color0}, #ff${color2}, #ff${color3}, #ff${color4}, #ff${color5}, #ff${color7}, #ff${color7}, #ff${color7}, #ff${color0}, #ff${color0}, #ff${color2}, #ff${color4}, #ff${color2}, #ff${color4}, #ff${color1}, #ff${color0}, #ff${color7}, #ff${color0}, #ff${color7}, #80${color2}
EOF

            cat >$HOME/dotfiles/extra/qt6ct/colors/mocha.conf <<EOF
[ColorScheme]
active_colors=#ff${color7}, #ff${color0}, #ff${color2}, #ff${color3}, #ff${color4}, #ff${color5}, #ff${color7}, #ff${color7}, #ff${color7}, #ff${color0}, #ff${color0}, #ff${color2}, #ff${color4}, #ff${color0}, #ff${color4}, #ff${color1}, #ff${color0}, #ff${color7}, #ff${color0}, #ff${color7}, #80${color2}
disabled_colors=#ff${color2}, #ff${color0}, #ff${color2}, #ff${color3}, #ff${color4}, #ff${color5}, #ff${color2}, #ff${color2}, #ff${color2}, #ff${color0}, #ff${color0}, #ff${color2}, #ff${color4}, #ff${color4}, #ff${color4}, #ff${color1}, #ff${color0}, #ff${color7}, #ff${color0}, #ff${color7}, #80${color2}
inactive_colors=#ff${color7}, #ff${color0}, #ff${color2}, #ff${color3}, #ff${color4}, #ff${color5}, #ff${color7}, #ff${color7}, #ff${color7}, #ff${color0}, #ff${color0}, #ff${color2}, #ff${color4}, #ff${color2}, #ff${color4}, #ff${color1}, #ff${color0}, #ff${color7}, #ff${color0}, #ff${color7}, #80${color2}
EOF

            pkill hyprlock

            if [ ! -w /opt/spotify ] || [ ! -w /opt/spotify/Apps ]; then
                pkexec chmod a+wr /opt/spotify
                pkexec chmod a+wr /opt/spotify/Apps -R
            fi

            mkdir -p $HOME/.config/spotify
            touch $HOME/.config/spotify/prefs

            cat >$HOME/.config/spicetify/Themes/Sleek/color.ini <<EOF
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

            spicetify config current_theme Sleek
            spicetify config color_scheme Pywal
            spicetify config extensions adblock.js
            spicetify apply

            if hyprctl clients | grep "Spotify"; then
                spicetify watch -s &
                sleep 1 && pkill spicetify
            fi

            last_value="$current_value"
        fi
    fi
done
