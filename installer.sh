#!/bin/sh

choose_edition() {
    echo "Choose Firefox stable or developer edition:"
    echo "1) Firefox stable"
    echo "2) Firefox developer edition"
    echo "Enter your choice: "
    read -r choice
    case $choice in
        1) edition="firefox";;
        2) edition="firefox-developer";;
        *) echo "Invalid choice. Please try again."; choose_edition;;
    esac
}

choose_language() {
    echo "Choose your language:"
    echo "1) English"
    echo "2) French"
    echo "3) German"
    echo "4) Italian"
    echo "5) Spanish"
    echo "6) Portuguese"
    echo "7) Dutch"
    echo "8) Russian"
    echo "9) Chinese Simplified"
    echo "10) Chinese Traditional"
    echo "11) Japanese"
    echo "12) Korean"
    echo "Enter your choice: "
    read -r choice
    case $choice in
        1) language="en-US";;
        2) language="fr";;
        3) language="de";;
        4) language="it";;
        5) language="es-ES";;
        6) language="pt-PT";;
        7) language="nl";;
        8) language="ru";;
        9) language="zh-CN";;
        10) language="zh-TW";;
        11) language="ja";;
        12) language="ko";;
        *) echo "Invalid choice. Please try again."; choose_language;;
    esac
}

get_download_url() {
    case $edition in
        firefox) download_url="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=$language";;
        firefox-developer) download_url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=$language";;
    esac
}

download_and_extract() {
    aurora_install_path="$HOME/.local/lib/firefox-aurora"
    stable_install_path="$HOME/.local/lib/firefox"
    if [ "$edition" = "firefox-developer" ]; then
        [ -d "$aurora_install_path" ] || mkdir -p "$aurora_install_path"
        rm -rf "$aurora_install_path"
        install_path=$aurora_install_path
    elif [ "$edition" = "firefox" ]; then
        [ -d "$stable_install_path" ] || mkdir -p "$stable_install_path"
        rm -rf "$stable_install_path"
        install_path=$stable_install_path
    fi
    mkdir -p "$install_path"
    echo "Downloading $edition..."
    wget -O /tmp/firefox.tar.xz "$download_url"
    echo "Extracting $edition..."
    tar -xvf /tmp/firefox.tar.xz -C /tmp
    cp -r /tmp/firefox/* "$install_path"
    rm /tmp/firefox.tar.xz
    rm -rf "/tmp/firefox"
}

install_desktop_entry() {
    if [ "$edition" = "firefox-developer" ]; then
        icon_name=firefox-dev
    elif [ "$edition" = "firefox" ]; then
        icon_name=firefox
    fi
    for icon_size in 16x16 32x32 48x48 64x64 128x128; do
        [ -d "$HOME/.local/share/icons/hicolor/$icon_size"/apps ] || mkdir -p "$HOME/.local/share/icons/hicolor/$icon_size"/apps
        [ -L "$HOME/.local/share/icons/hicolor/$icon_size/apps/$icon_name.png" ] && rm "$HOME/.local/share/hicolor/icons/$icon_size/apps/$icon_name.png"
    done
    for size in 16 32 48 64 128; do
        ln -s "$install_path/browser/chrome/icons/default/default$size.png" "$HOME/.local/share/icons/hicolor/""$size""x""$size""/apps/$icon_name.png"
    done
    wget -O "$HOME/.local/share/applications/""$icon_name"".desktop" "https://github.com/MarksonHon/firefox-linux-installer/raw/refs/heads/main/firefox-desktops/$icon_name.desktop"
}

choose_edition
choose_language
get_download_url
download_and_extract
install_desktop_entry
echo "If the Firefox icon is not a firefox icon but a blank one,"
echo "you should run these commands:"
echo 'cat << EOF | sudo tee /etc/profile.d/99-home-path.sh
XDG_DATA_DIRS=\$HOME/.local/share:\$XDG_DATA_DIRS
PATH=\$HOME/.local/bin:\$PATH
EOF'
echo "Then relogin or reboot your system."