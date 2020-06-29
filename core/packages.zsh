#!/usr/bin/env ksh

# -*- coding: utf-8 -*-
export GOENV_PACKAGES=(
    github.com/onsi/ginkgo/ginkgo
    github.com/onsi/gomega
    github.com/pengwynn/flint
    github.com/dougm/goflymake
    # ide
    github.com/mdempsky/gocode
    github.com/rogpeppe/godef
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/gorename
    golang.org/x/tools/gopls@latest
    golang.org/x/tools/cmd/guru
    github.com/davidrjenni/reftools/cmd/fillstruct
    github.com/josharian/impl
    github.com/haya14busa/gopkgs/cmd/gopkgs
    github.com/godoctor/godoctor
    github.com/zmb3/gogetdoc
    github.com/fatih/gomodifytags
    github.com/cweill/gotests/...
    # tools
    github.com/99designs/aws-vault
    github.com/minamijoyo/myaws/myaws
    github.com/kardianos/govendor
    github.com/motemen/ghq
    # debug
    github.com/go-delve/delve/cmd/dlv
    # validators
    github.com/BurntSushi/toml/cmd/tomlv
    github.com/fzipp/gocyclo
    github.com/go-critic/go-critic/cmd/gocritic
    golang.org/x/lint/golint
)

function goenv::packages::install {
    if ! type -p go > /dev/null; then
        message_warning "it's neccesary have go"
        return
    fi

    message_info "Installing required go packages"
    # binary will be $(go env GOPATH)/bin/golangci-lint
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin v1.27.0

    for package in "${GOENV_PACKAGES[@]}"; do
       GO111MODULE=on go get -u -v "${package}"
    done
    message_success "Installed required Go packages"
}
