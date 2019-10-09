#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines install g for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

LIGHT_GREEN='\033[1;32m'
CLEAR='\033[0m'

function goenv::install {
    echo -e "${CLEAR}${LIGHT_GREEN}Installing G${CLEAR}"
    git clone https://github.com/syndbg/goenv.git ~/.goenv
    goenv::post_install
}

function goenv::init {
    eval "$(goenv init -)"
    [[ -e "$GOROOT/bin" ]] && export PATH="$GOROOT/bin:$PATH"
    [[ -e "$GOPATH/bin" ]] && export PATH="$GOPATH/bin:$PATH"
}

function goenv::post_install {
    goenv::load
    if (( $+commands[goenv] )); then
        echo -e "${CLEAR}${LIGHT_GREEN} Install Go ${CLEAR}"
        goenv install 1.13.1
        goenv global 1.13.1
        echo -e "${CLEAR}${LIGHT_GREEN}Installing required go packages${CLEAR}"
        go get -u github.com/alecthomas/gometalinter && gometalinter --install
        go get -u github.com/onsi/ginkgo/ginkgo
        go get -u github.com/onsi/gomega
        go get -u github.com/nsf/gocode
        go get -u golang.org/x/tools/cmd/goimports
        go get -u github.com/pengwynn/flint
        go get -u github.com/rogpeppe/godef
        go get -u github.com/dougm/goflymake
        # tools
        go get -u github.com/99designs/aws-vault
        go get -u github.com/minamijoyo/myaws/myaws
    fi
}

function goenv::load {
    [[ -e "$HOME/.goenv" ]] && export GOENV_ROOT="$HOME/.goenv"
    [[ -e "$HOME/.goenv/bin" ]] && export PATH="$GOENV_ROOT/bin:$PATH"
    if (( $+commands[goenv] )); then
        goenv::init
    fi
}

goenv::load

if (( ! $+commands[goenv] )); then
    goenv::install
fi
