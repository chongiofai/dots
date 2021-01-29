# DOTS

## configure
1. vim
2. tmux
3. readline
4. xrdb

## statice
1. fonts
    - JetBrainsMono
2. consolefonts
    - tamsync-font
    - tamzen-font
3. autoload
    1. vim
        - vim-plug
    2. tmux
        - tpm

## operate
1. `make static`
    download static resource(autoload plugins, fonts, consolefonts...)
2. `make pull`
    rsync current configure to this repository
3. `make push`
    install repo config
4. `make npull/npush`
    dry run pull and push
5. `make clean`
