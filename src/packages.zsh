#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
export GOENV_PACKAGES=(
    github.com/onsi/ginkgo/ginkgo
    github.com/onsi/gomega
    github.com/nsf/gocode
    golang.org/x/tools/cmd/goimports
    github.com/pengwynn/flint
    github.com/rogpeppe/godef
    github.com/dougm/goflymake
    # tools
    github.com/99designs/aws-vault
    github.com/minamijoyo/myaws/myaws
    github.com/kardianos/govendor
    github.com/motemen/ghq
    # validators
    github.com/BurntSushi/toml/cmd/tomlv
)

function goenv::packages::install {
    if ! type -p go > /dev/null; then
        message_warning "it's neccesary have go"
        return
    fi

    message_info "Installing required go packages"
    # binary will be $(go env GOPATH)/bin/golangci-lint
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin v1.23.6

    for package in "${GOENV_PACKAGES[@]}"; do
        go get -u "${package}"
    done
    message_success "Installed required Go packages"
}
