#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

host_icon=$(get_tmux_option "@tmux2k-host-icon" "󰒋")

main() {
    echo "$host_icon #H"
}

main
