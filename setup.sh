#!/bin/bash
# encoding=utf-8

set -x
set -e

BASE_DIR="$(cd "$(dirname "${BASE_SOURCE[0]}")" 2>&1 && pwd)"

confirm() {
    while true; do
        if [[ -n "$COMFIRM" ]]; then
            yn="$COMFIRM"
        else
            read -r yn
        fi
        case $yn in
        "y" | "Y")
            $*
            break
            ;;
        "n" | "N")
            echo "cancel"
            break
            ;;
        *)
            echo "[yn]"
            ;;
        esac
    done
}

bak() {
    rsync -n -rac -i -v \
        --include=".[^.]*" \
        --ignore-non-existing \
        "$HOME/" "$BASE_DIR/"
    echo "rsync[yn]"
    confirm rsync -rac -i -vv \
        --include=".[^.]*" \
        --ignore-non-existing \
        "$HOME/" "$BASE_DIR/"
}

dots() {
    rsync -n -rac -i -v \
        --exclude-from="$BASE_DIR/.gitignore" \
        --exclude=".git" \
        --exclude=".gitignore" \
        --exclude="README.md" \
        --exclude="setup.sh" \
        "$BASE_DIR/" "$HOME/"
    echo "rsync[yn]"
    confirm rsync -rac --backup --suffix=".bak" -i -vv \
        --exclude-from="$BASE_DIR/.gitignore" \
        --exclude=".git" \
        --exclude=".gitignore" \
        --exclude="README.md" \
        --exclude="setup.sh" \
        "$BASE_DIR/" "$HOME/"
}

tmux-plugin() {
    TPM_PATH="$HOME/.tmux/plugins/tpm"
    if [[ -d "$TPM_PATH" ]]; then
        echo "update tmux plugin[yn]"
        confirm $TPM_PATH/bindings/update_plugins
    else
        echo "install tmux tpm plugin[yn]"
        confirm git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" && $TPM_PATH/bindings/install_plugins
    fi
}

vim_plugin() {
    PLUGVIM_PATH="$HOME/.vim/autoload/plug.vim"
    if [[ -f "$PLUGVIM_PATH" ]]; then
        echo "update vim plugin[yn]"
        confirm vim +PlugUpdate
    else
        echo "download plug-vim"
        confirm curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim +PlugInstall!
    fi
}

fzf() {
    FZF_PATH="$HOME/.fzf"
    if [[ ! -d "$FZF_PATH" ]]; then
        echo "download fzf[yn]"
        confirm git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_PATH && $FZF_PATH/install
    fi
}

pyenv() {
    PYENV_PATH="$HOME/.fzf"
    if [[ ! -d "$PYENV_PATH" ]]; then
        echo "install pyenv"
        confirm curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    fi
}

xrdb() {
    echo "merge xrdb[yn]"
    confirm xrdb -merge "$HOME/.Xresources"
}

fonts() {
    echo "donwload JetBainsMono[yn]"
    confirm 'git clone https://github.com/JetBrains/JetBrainsMono.git ./tmp/JetBrainsMono && rsync -rac -ivv "tmp/JetBrainsMono/fonts/ttf/*.ttf" "$HOME/.local/share/fonts/JetBrainsMono/"'
    echo "donwload WenQuanYi Micro[yn]"
    confirm 'sudo apt install -y fonts-wqy-microhei'
    echo "donwload Symbola[yn]"
    confirm 'curl --create-dirs  -o ./tmp/symbola.zip https://fontlibrary.org/assets/downloads/symbola/cf81aeb303c13ce765877d31571dc5c7/symbola.zip && unzip -d ./tmp/symbola ./tmp/symbola.zip && rsync -rac -ivv "tmp/symbola/*.ttf" "$HOME/.local/share/fonts/symbola/"'
}

console-fonts() {
    echo "download tamzen-font[yn]"
    confirm git clone https://github.com/sunaku/tamzen-font.git ./tmp/tamzen-font && rsync -rac -ivv "tmp/tamzen-font/psf/*.psf" "$HOME/.local/share/"
}

rm -rf $BASE_DIR/tmp
[ -z $* ] && echo "setup.sh [bak|dots|fzf|pyenv|vim-plugin|tmux-plugin|fonts|consolefonts|xrdb]"
for cmd in $*; do
    case $cmd in
    "help")
        echo "setup.sh [bak|dots|fzf|pyenv|vim-plugin|tmux-plugin|fonts|consolefonts|xrdb]"
        ;;
    *)
        $cmd
        ;;
    esac
done

# set +x
# set +e
