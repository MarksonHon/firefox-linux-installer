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
    aurora_install_path=~/.local/lib/firefox-aurora
    stable_install_path=~/.local/lib/firefox
    if [ "$edition" = "firefox-developer" ]; then
        [ -d $aurora_install_path ] || mkdir -p $aurora_install_path
        install_path=$aurora_install_path
    elif [ "$edition" = "firefox" ]; then
        [ -d $stable_install_path ] || mkdir -p $stable_install_path
        install_path=$stable_install_path
    fi
    echo "Downloading $edition..."
    wget -O /tmp/firefox.tar.bz2 "$download_url"
    echo "Extracting $edition..."
    tar -xjf /tmp/firefox.tar.bz2 -C "$install_path"
    rm /tmp/firefox.tar.bz2
}

choose_edition
choose_language
get_download_url
download_and_extract
