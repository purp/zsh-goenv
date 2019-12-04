#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines install goenv for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#
goenv_package_name=goenv

ZSH_GOENV_PATH_ROOT=$(dirname "${0}":A)

# shellcheck source=/dev/null
source "${ZSH_GOENV_PATH_ROOT}"/src/helpers/messages.zsh

# shellcheck source=/dev/null
source "${ZSH_GOENV_PATH_ROOT}"/src/helpers/tools.zsh

function goenv::install {
    message_info "Installing dependences for ${goenv_package_name}"
    git clone https://github.com/syndbg/goenv.git ~/.goenv
    message_success "Installed dependences for ${goenv_package_name}"
}

function goenv::upgrade {
    message_info "Upgrade for ${goenv_package_name}"
    local path_goenv
    path_goenv=$(goenv root)
    # shellcheck disable=SC2164
    exec cd "${path_goenv}" && git pull && cd -
    message_success "Upgraded ${goenv_package_name}"
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
        message_info "Install versions of Go"
        goenv install 1.13.1
        goenv global 1.13.1
        message_success "Installed versions of Go"
        message_info "Installing required go packages"
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
        message_success "Installed required Go packages"
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
    goenv::post_install
fi
