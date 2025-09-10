#!/bin/bash

SCRIPT_DIR="$HOME/.config/hypr/scripts/themesscript"
ICON_DIR="$HOME/.config/hypr/icons"

MENU=""
while IFS= read -r file; do
  name=$(basename "$file" .sh)
  icon="$ICON_DIR/${name,,}.png"
  MENU+="${name}\x0icon\x1f${icon}\n"
done < <(find "$SCRIPT_DIR" -type f -name "*.sh")

SELECTED=$(echo -en "$MENU" | rofi -dmenu -show-icons -p "Choose Theme")

# Проверка и запуск выбранного скрипта
if [[ -n "$SELECTED" ]]; then
  bash "$SCRIPT_DIR/${SELECTED}.sh"
fi
