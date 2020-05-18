#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines install goenv for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

goenv_package_name=goenv
export GOENV_ROOT="${HOME}/.goenv"

# shellcheck disable=SC2034  # Unused variables left for readability
GOENV_ROOT_DIR=$(dirname "$0")
GOENV_SRC_DIR="${GOENV_ROOT_DIR}"/src

# shellcheck source=/dev/null
source "${GOENV_SRC_DIR}"/base.zsh


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
    cd "${path_goenv}" && git pull && cd -
    message_success "Upgraded ${goenv_package_name}"
}

function goenv::init {
    local goenv_path goenv_global goroot
    goenv_path=$(go env GOPATH)
    goenv_global=$(goenv global)
    goroot=$(goenv prefix)
    eval "$(goenv init -)"
    [ -e "${GOPATH}/bin" ] && export PATH="${goenv_path}/bin:${PATH}"
    [ -e "${GOENV_ROOT}/versions/${goenv_global}/bin" ] && export PATH="${GOENV_ROOT}/versions/${goenv_global}/bin:${PATH}"
    export GOROOT="${goroot}"
}

function goenv::post_install {
    goenv::load
    if type -p goenv > /dev/null; then
        message_info "Install versions of Go"
        goenv install 1.13.1
        goenv install 1.13.4
        goenv global 1.13.1
        message_success "Installed versions of Go"
    fi
}

function goenv::packages {
    if ! type -p go > /dev/null; then
        message_warning "it's neccesary have go"
        return
    fi

    message_info "Installing required go packages"
    # binary will be $(go env GOPATH)/bin/golangci-lint
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin v1.23.6
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
    # validators
    go get -u github.com/BurntSushi/toml/cmd/tomlv
    message_success "Installed required Go packages"
}

function goenv::load {
    [ -e "${GOENV_ROOT}/bin" ] && export PATH="${PATH}:${GOENV_ROOT}/bin"
    [ -e "${GOENV_ROOT}/shims" ] && export PATH="${GOENV_ROOT}/shims:${PATH}"
    if type -p goenv > /dev/null; then
        goenv::init
        [ -e "${GOROOT}/bin" ] && export PATH="${GOROOT}/bin:${PATH}"
        [ -e "${GOPATH}/bin" ] && export PATH="${PATH}:${GOPATH}/bin"
    fi
}

goenv::load

if ! type -p goenv > /dev/null; then
    goenv::install
    goenv::post_install
fi
