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
    echo -e "${CLEAR}${LIGHT_GREEN}Installing Goenv${CLEAR}"
    git clone https://github.com/syndbg/goenv.git ~/.goenv
    goenv::post_install
}

function goenv::upgrade {
    echo -e "${CLEAR}${LIGHT_GREEN}upgrade Goenv${CLEAR}"
    local path_goenv
    path_goenv=$(goenv root)
	  # shellcheck disable=SC2164
    cd "${path_goenv}" && git pull && cd -
}

function goenv::init {
    local goenv_path
    local goenv_global
    goenv_path=$(go env GOPATH)
    goenv_global=$(goenv global)
    [[ -e "${GOPATH}/bin" ]] && export PATH="${goenv_path}/bin:${PATH}"
    [[ -e "${GOENV_ROOT}/versions/${goenv_global}/bin" ]] && export PATH="${GOENV_ROOT}/versions/${goenv_global}/bin:${PATH}"
}

function goenv::post_install {
    goenv::load
    if [ -x "$(command which goenv)" ]; then
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
        go get -u github.com/kardianos/govendor
        go get -u github.com/motemen/ghq
    fi
}

function goenv::load {
    [[ -e "$HOME/.goenv" ]] && export GOENV_ROOT="$HOME/.goenv"
    [[ -e "$HOME/.goenv/bin" ]] && export PATH="$GOENV_ROOT/bin:$PATH"
    [[ -e "$HOME/.goenv/shims" ]] && export PATH="$HOME/.goenv/shims:$PATH"
    if [ -x "$(command which goenv)" ]; then
        goenv::init
    fi
}

goenv::load

if [ ! -x "$(command which goenv)" ]; then
    goenv::install
fi
