#!/bin/sh
echo -ne '\033c\033]0;GameJam Brackeys\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/overforged.x86_64" "$@"
