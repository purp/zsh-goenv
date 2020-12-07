#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
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
