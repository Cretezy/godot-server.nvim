#!/usr/bin/env bash

# Replace with your terminal emulator executable
term_exec="kitty"

# Optional: Replace with your Neovim executable
nvim_exec="nvim"


server_path=".godot/server.pipe"
filename=$(printf %q "$1") # Escaping
cursor=$2

start_server() {
    "$term_exec" "$nvim_exec" --listen "$server_path" "+call cursor($cursor)" "$filename"
}

open_file_in_server() {
    "$nvim_exec" --server "$server_path" --remote-send "<C-\><C-n>:e $filename<CR>:call cursor($cursor)<CR>"
}

# Check if server is currently running
if ! [ -e ".godot/server.pipe" ]; then
    start_server &
else
    open_file_in_server
fi
