#!/bin/bash
# Installs the desktop pieces for the Hyprland setup and turns on the login
# screen. Safe to run twice. Run it with: sudo bash ~/hypr-setup/install.sh
set -euo pipefail
(( EUID == 0 )) || exec sudo bash "$0" "$@"
here=$(dirname "$(readlink -f "$0")")

packages=(
  # bar, notifications, launcher, wallpaper, lock and idle
  waybar mako fuzzel hyprpaper hyprlock hypridle
  # polkit prompts, secrets, file pickers and screen sharing
  hyprpolkitagent gnome-keyring xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
  # clipboard history, screenshots, color picker
  cliphist wl-clipboard grim slurp satty hyprpicker
  # volume/brightness popups and media keys
  swayosd playerctl brightnessctl
  # audio, bluetooth and network panels (network uses nmtui from NetworkManager)
  wiremix bluetui bluez bluez-utils
  # icons and emoji
  papirus-icon-theme noto-fonts-emoji
  # login screen
  greetd greetd-tuigreet
  # tools your ~/.zshrc expects, removed with Omarchy (cd is aliased to zoxide)
  zoxide starship fzf eza bat fd tmux jq
)
pacman -Syu --needed "${packages[@]}"

# greetd.toml runs a patched tuigreet (night-sky background, --border-corner)
# from ~/git/tuigreet, branch night-sky, installed to /usr/local/bin so pacman
# never overwrites it. On a fresh machine it is cloned at 0.11.1 and patched
# with tuigreet-night-sky.patch; built as evan, not root, if there's no build.
tg=/home/evan/git/tuigreet
if [[ ! -d $tg ]]; then
  sudo -u evan git clone --branch 0.11.1 https://github.com/tuigreet/tuigreet.git "$tg"
  sudo -u evan git -C "$tg" switch -c night-sky
  sudo -u evan git -C "$tg" apply "$here/tuigreet-night-sky.patch"
fi
if [[ ! -x $tg/target/release/tuigreet ]]; then
  sudo -u evan bash -lc "cd '$tg' && cargo +stable build --release --locked"
fi
install -Dm755 "$tg/target/release/tuigreet" /usr/local/bin/tuigreet

install -Dm644 "$here/greetd.toml" /etc/greetd/config.toml

# Unlock the GNOME keyring with the login password at the greeter.
pam=/etc/pam.d/greetd
grep -q '^auth.*pam_gnome_keyring' "$pam" || sed -i '/^auth.*include/a auth       optional     pam_gnome_keyring.so' "$pam"
grep -q '^session.*pam_gnome_keyring' "$pam" || echo 'session    optional     pam_gnome_keyring.so auto_start' >>"$pam"

systemctl enable bluetooth.service greetd.service
echo
echo "Done. The login screen takes over tty1 from the next boot."
