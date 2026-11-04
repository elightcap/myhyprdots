#!/bin/bash
# Shows the login screen exactly as configured in greetd.toml, in this
# terminal, without logging anyone in (tuigreet --mock). Esc, then Ctrl+C to quit.
#
# The real login runs on the Linux console, whose 16 colours are set on the
# kernel command line (vt.default_* in /etc/default/limine). Terminal themes
# differ (kitty's Catppuccin uses #45475a for colour 0, for example), so the
# console palette is loaded into this terminal for the preview (OSC 4) and the
# terminal's own palette is restored afterwards (OSC 104).
here=$(dirname "$(readlink -f "$0")")
palette=(1e1e2e f38ba8 a6e3a1 f9e2af 89b4fa f5c2e7 94e2d5 bac2de
         585b70 eba0ac 11111b fab387 b4befe cba6f7 89dceb cdd6f4)
for i in "${!palette[@]}"; do printf '\e]4;%d;#%s\e\\' "$i" "${palette[i]}"; done
printf '\e]11;#%s\e\\' "${palette[0]}"
trap 'printf "\e]104\e\\\e]111\e\\"' EXIT

cmd=$(python3 -I -c 'import sys, tomllib; print(tomllib.load(open(sys.argv[1], "rb"))["default_session"]["command"])' "$here/greetd.toml")
sh -c "$cmd --mock"
