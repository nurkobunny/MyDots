#!/bin/bash

# Скрипт для переключения темы Firefox
# ID вашей темы: {f2dc20e1-4161-44e5-985c-6cc613ff1669}

# ==============================================
# НАСТРОЙКА ПУТЕЙ
# ==============================================
FIREFOX_DIR="$HOME/.mozilla/firefox"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"
YOUR_THEME_ID="{f2dc20e1-4161-44e5-985c-6cc613ff1669}"


# ==============================================
# ОСНОВНОЙ КОД СКРИПТА
# ==============================================

# Получаем путь к профилю
PROFILE_DIR= "/home/nurkobunny/.mozilla/firefox/6x217xzw.default-release/"
PREFS_FILE="/home/nurkobunny/.mozilla/firefox/6x217xzw.default-release/prefs.js"
EXTENSIONS_DIR="$PROFILE_DIR/extensions"



# Функция для установки вашей темы
set_your_theme() {
    echo "Установка вашей темы..."
    
    # Проверяем, установлена ли тема
    if [ ! -f "$EXTENSIONS_DIR/$YOUR_THEME_ID.xpi" ] && [ ! -d "$EXTENSIONS_DIR/$YOUR_THEME_ID" ]; then
        echo "Тема не найдена в директории расширений!"
        echo "Убедитесь, что тема установлена через магазин расширений Firefox"
        return 1
    fi
    
    # Устанавливаем тему через редактирование prefs.js
    if [ -f "$PREFS_FILE" ]; then
        # Удаляем старые настройки темы
        sed -i '/extensions.activeThemeID/d' "$PREFS_FILE"
        # Добавляем новую настройку
        echo "user_pref(\"extensions.activeThemeID\", \"$YOUR_THEME_ID\");" >> "$PREFS_FILE"
        echo "✅ Тема успешно установлена!"
        echo "🔄 Перезапустите Firefox для применения изменений"
    else
        echo "Ошибка: Файл настроек prefs.js не найден"
        return 1
    fi
}

# Функция для проверки текущей темы
check_current_theme() {
    if [ -f "$PREFS_FILE" ]; then
        local current_theme=$(grep 'extensions.activeThemeID' "$PREFS_FILE" | cut -d'"' -f4)
        if [ -n "$current_theme" ]; then
            echo "Текущая тема: $current_theme"
            if [ "$current_theme" = "$YOUR_THEME_ID" ]; then
                echo "✅ Ваша тема активна!"
            else
                echo "❌ Ваша тема не активна"
            fi
        else
            echo "Используется тема по умолчанию"
        fi
    else
        echo "Файл настроек prefs.js не найден"
    fi
}

# Функция для проверки установлена ли тема
check_theme_installed() {
    if [ -f "$EXTENSIONS_DIR/$YOUR_THEME_ID.xpi" ] || [ -d "$EXTENSIONS_DIR/$YOUR_THEME_ID" ]; then
        echo "✅ Тема установлена: $YOUR_THEME_ID"
    else
        echo "❌ Тема не найдена в директории расширений"
        echo "Путь: $EXTENSIONS_DIR/"
    fi
}

# Обработка аргументов командной строки
case "$1" in
    set|--set)
        set_your_theme
        ;;
    check|--check)
        check_current_theme
        ;;
    status|--status)
        check_theme_installed
        check_current_theme
        ;;
    help|--help|-h)
        echo "Использование: $0 [команда]"
        echo "Команды:"
        echo "  set       - Установить вашу тему"
        echo "  check     - Проверить текущую тему"
        echo "  status    - Показать статус темы"
        echo "  help      - Показать эту справку"
        ;;
    *)
        echo "🔥 Скрипт переключения темы Firefox"
        echo "📝 ID вашей темы: $YOUR_THEME_ID"
        echo ""
        echo "Использование: $0 [set|check|status|help]"
        echo ""
        check_theme_installed
        echo ""
        check_current_theme
        ;;
esac
