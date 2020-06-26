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
GOENV_SRC_DIR="${GOENV_ROOT_DIR}"
GOENV_VERSIONS=(
    1.13.0
    1.13.1
    1.13.2
    1.13.4
    1.14.0
    1.14.1
    1.14.2
)
GOENV_VERSION_GLOBAL=1.14.2

# shellcheck source=/dev/null
source "${GOENV_SRC_DIR}"/core/base.zsh

# shellcheck source=/dev/null
source "${GOENV_SRC_DIR}"/core/packages.zsh


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
    if ! type -p goenv > /dev/null; then
        message_warning "not found goenv"
        return
    fi
    message_info "Install versions of Go"
    for version in "${GOENV_VERSIONS[@]}"; do
        goenv install "${version}"
    done
    goenv global "${GOENV_VERSION_GLOBAL}"
    message_success "Installed versions of Go"
}


function goenv::load {
    [ -e "${GOENV_ROOT}/bin" ] && export PATH="${PATH}:${GOENV_ROOT}/bin"
    [ -e "${GOENV_ROOT}/shims" ] && export PATH="${GOENV_ROOT}/shims:${PATH}"
    if type -p goenv > /dev/null; then
        goenv::init
        [ -e "${GOROOT}/bin" ] && export PATH="${GOROOT}/bin:${PATH}"
        [ -e "${GOPATH}/bin" ] && export PATH="${PATH}:${GOPATH}/bin"
        export GO111MODULES=on
    fi
}

goenv::load

if ! type -p goenv > /dev/null; then
    goenv::install
    goenv::post_install
fi
