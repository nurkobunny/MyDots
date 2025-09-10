#!/bin/bash

# ── Папки с темами (укажешь позже)
declare -A WALL_DIRS
WALL_DIRS["Gruvbox"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/GruvBox/"
WALL_DIRS["Catppuccin"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/Catppuchine/"
WALL_DIRS["TokyoNight"]="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/TokyoNight/"

# ── Выбор темы
THEME=$(printf "%s\n" "${!WALL_DIRS[@]}" | rofi -dmenu -p "Выбери тему")

[[ -z "$THEME" ]] && exit 0

DIR="${WALL_DIRS[$THEME]}"
[[ ! -d "$DIR" ]] && exit 1

# ── Генерация списка изображений с иконками
MENU=""
while IFS= read -r file; do
  name=$(basename "$file")
  MENU+="${name}\x0icon\x1f${file}\n"
done < <(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \))

SELECTED=$(echo -en "$MENU" | rofi -dmenu -show-icons -theme ~/.config/rofi/config-wallpaper.rasi -p "Выбери обои")

[[ -z "$SELECTED" ]] && exit 0

# ── Применение обоев (пример через swww)
WALL="$DIR/$SELECTED"
CURRENTWALL="$HOME/Pictures/wallpapers/current"
rm -f "$CURRENTWALL"/*

cp "$WALL" "$CURRENTWALL/"
swww img "$WALL" --transition-type any --transition-fps 60 --transition-duration 1
~/.config/hypr/scripts/update_hyprlock_wallpaper.sh
sudo cp $HOME/Pictures/wallpapers/current/* /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/default
