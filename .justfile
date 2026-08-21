#!/usr/bin/env -S just --justfile

set minimum-version := '1.55.0'

set default-list
set default-script
set lazy
set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[group('Bootstrap')]
mod bootstrap "bootstrap"

[group('Kube')]
mod kube "kubernetes"

[group('Talos')]
mod talos "talos"

[group('Infrastructure')]
mod infra "infrastructure"

[private]
default:
    just -l

[private]
log lvl msg *args:
    gum log -t rfc3339 -s -l "{{ lvl }}" "{{ msg }}" {{ args }}

[private]
template file *args:
    if [[ "{{ file }}" == "-" ]]; then
        minijinja-cli --config-file .minijinja.toml - {{ args }}
    else
        if grep -qE '^sops:[[:space:]]*(#.*)?$' "{{ file }}"; then
            sops decrypt --input-type yaml --output-type yaml "{{ file }}"
        else
            cat "{{ file }}"
        fi | minijinja-cli --config-file .minijinja.toml - {{ args }}
    fi
