#!/bin/zsh
# ── Gruvbox Theme Switcher ──

### 🖼️ GTK Theme
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Gruvbox-Material-Dark"
sleep 1

### 🎨 Hyprland UserDecorations.conf — обновление рамок
USER_DECOR="$HOME/.config/hypr/UserConfigs/UserDecorations.conf"
sed -i 's/^.*col\.active_border.*/col.active_border = rgb(d79911)/' "$USER_DECOR"
sed -i 's/^.*col\.inactive_border.*/col.inactive_border = rgb(3c3836)/' "$USER_DECOR"
sleep 1

### 🖼️ Случайные обои Gruvbox через swww
WALL_DIR="$HOME/Pictures/wallpapers/Dynamic-Wallpapers/GruvBox/"
WALL=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
CURRENTWALL="$HOME/Pictures/wallpapers/current"
rm -f "$CURRENTWALL"/*

cp "$WALL" "$CURRENTWALL/"

if command -v swww &> /dev/null; then
    swww query || swww init
    swww img "$WALL" --transition-type any --transition-fps 60 --transition-duration 1
else
    echo "❌ swww не найден. Установи его для смены обоев."
fi
sleep 1
#Hyprlock
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlockthemes/GruvBox.conf"
cp "$HYPRLOCK_CONFIG" "$HOME/.config/hypr/hyprlock.conf"
~/.config/hypr/scripts/update_hyprlock_wallpaper.sh
sleep 1
#SDDM
#THEMESDDM="japanesse_aesthetic.conf"
#TARGET_FILE="/usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"

#sudo sed -i "s|^ConfigFile=Themes/.*|ConfigFile=Themes/$THEMESDDM|" "$TARGET_FILE"

sudo cp $HOME/Pictures/wallpapers/current/* /usr/share/sddm/themes/simple_sddm_2/Backgrounds/default
WALLALLDIREC=$HOME"/Pictures/fastfetch/gruvbox"
WALLFASTDIREC=$HOME"/Pictures/fastfetch/curent"

THEMEFOLDER="/usr/share/grub/themes/"
THEME="tartarus"
GRUBCONF="/etc/default/grub"

# Добавляем или заменяем строку GRUB_THEME
if grep -q "^GRUB_THEME=" "$GRUBCONF"; then
   sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"${THEMEFOLDER}${THEME}/theme.txt\"|" "$GRUBCONF"
else
    echo "GRUB_THEME=\"${THEMEFOLDER}${THEME}/theme.txt\"" | sudo tee -a "$GRUBCONF" > /dev/null
fi

# Обновляем конфигурацию GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Создаем директорию если не существует
mkdir -p "$WALLFASTDIREC"

# Находим случайное изображение
WALLFAST=$(find "$WALLALLDIREC" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

# Удаляем все старые файлы в целевой директории
rm -f "$WALLFASTDIREC"/*

# Копируем выбранное изображение в целевую директорию
cp "$WALLFAST" "$WALLFASTDIREC/"
sleep 1
### 🐱 Kitty — переключение темы
kitten theme Gruvbox Material Dark Hard
sleep 1

#CAVA
CAVA_CONFIG="$HOME/.config/cava/config"
BACKGROUND="default"
FOREGROUND="#ccb793"
GRADIENT=0
GRADIENT_COLOR_1="#7aa2f7"
GRADIENT_COLOR_2="#bb9af7"
GRADIENT_COLOR_3="#9aa5ce"

sed -i "s|^background *=.*|background = $BACKGROUND|" "$CAVA_CONFIG"
sed -i "s|^foreground *q=.*|foreground = \{$FOREGROUND}\|" "$CAVA_CONFIG"
sed -i "s|^gradient *=.*|gradient = $GRADIENT|" "$CAVA_CONFIG"
sed -i "s|^gradient_color_1 *=.*|gradient_color_1 = \"$GRADIENT_COLOR_1\"|" "$CAVA_CONFIG"
sed -i "s|^gradient_color_2 *=.*|gradient_color_2 = \"$GRADIENT_COLOR_2\"|" "$CAVA_CONFIG"
sed -i "s|^gradient_color_3 *=.*|gradient_color_3 = \"$GRADIENT_COLOR_3\"|" "$CAVA_CONFIG"

#pipes.sh & tty-clock
PIPES="pipes.sh -c 7 -f 60"
sed -i 's|^alias pipes\.sh=.*|alias pipes.sh="'"$PIPES"'"|' ~/.zshrc
CLOCK="tty-clock -c -C 7"
sed -i 's|^alias tty-clock=.*|alias tty-clock="'"$CLOCK"'"|' ~/.zshrc

### 📘 Obsidian — смена темы
OBSIDIAN_THEME_NAME="Material Gruvbox"  # Название темы, как она указана в Obsidian
OBSIDIAN_CONFIG="/run/media/nurkobunny/Disk1/notes/.obsidian/appearance.json"  # Укажешь свой путь

if [ -f "$OBSIDIAN_CONFIG" ]; then
    sed -i "s/\"cssTheme\": *\".*\"/\"cssTheme\": \"$OBSIDIAN_THEME_NAME\"/" "$OBSIDIAN_CONFIG"
else
    echo "⚠️ appearance.json не найден. Укажи путь вручную: $OBSIDIAN_CONFIG"
fi
pkill -f "/usr/lib/obsidian/app.asar"
VAULT_PATH="/run/media/nurkobunny/Disk1/notes"
electron37 /usr/lib/obsidian/app.asar "$VAULT_PATH" & disown

sleep 1

### 🧠 VSCode OSS — смена темы
VSCODE_SETTINGS="$HOME/.config/Code - OSS/User/settings.json"
if [ -f "$VSCODE_SETTINGS" ]; then
    sed -i 's/"workbench.colorTheme": *".*"/"workbench.colorTheme": "Gruvbox Material Dark"/' "$VSCODE_SETTINGS"
else
    echo "⚠️ settings.json не найден. Проверь путь вручную."
fi
sleep 1

### 📊 Waybar
WAYBAR_CONFIG="$HOME/.config/waybar/style/GruvBox.css"
cp "$WAYBAR_CONFIG" "$HOME/.config/waybar/style.css"
killall waybar && waybar & disown
sleep 1

### 🧠 Rofi
ROFI_THEME="$HOME/.config/rofi/themes/GruvBoxKool-4.rasi"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
sed -i 's/^\s*@theme/\/\/@theme/' "$ROFI_CONFIG"
echo "@theme \"$ROFI_THEME\"" >> "$ROFI_CONFIG"
sleep 1

# 🔍 Находим профиль Firefox
PROFILE_DIR=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default-release" | head -n 1)
CHROME_DIR="$PROFILE_DIR/chrome"
SOURCE_CSS="$HOME/.config/firefox-themes/gruvbox/userChrome.css"

# 📦 Копируем с заменой
cp -f "$SOURCE_CSS" "$CHROME_DIR/userChrome.css"

pkill firefox
sleep 1
nohup firefox &> /dev/null &


### 🎵 Spotify (Spicetify)
pkill spotify
spicetify config color_scheme Gruvbox
spicetify apply
sleep 0.5
spotify & disown
sleep 0.5
echo "now kitty reload..."
sleep 1
pkill -x kitty
kitty & disown
