# myhyprdots

Arch + Hyprland in Catppuccin Mocha, themed all the way from the bootloader to
the bar: Limine menu → Plymouth splash with the LUKS prompt → a night-sky
tuigreet login on the console → Hyprland.

![tuigreet login: block-letter HYPRLAND over a starfield with a crescent moon](docs/greeter.png)

## What's here

| Path | Goes to | What it is |
| --- | --- | --- |
| `config/` | `~/.config/` | Hyprland (Lua config + scripts), hyprlock, hypridle, waybar, kitty, mako, fuzzel, rofi, btop, GTK, qt6ct, starship |
| `setup/install.sh` | run with sudo | Installs the packages, builds the patched tuigreet, enables greetd |
| `setup/greetd.toml` | `/etc/greetd/config.toml` | The login screen: tuigreet with the `night` background and HYPRLAND banner |
| `setup/make-banner.py` | | Regenerates the block-letter banner in `greetd.toml` (`./make-banner.py WORD`) |
| `setup/preview-greeter.sh` | | Shows the login screen in your terminal without logging in (`--mock`) |
| `setup/tuigreet-night-sky.patch` | | tuigreet 0.11.1 + `--background night` (twinkling stars, crescent moon, shooting stars, the odd satellite) and `--border-corner` |
| `boot/limine/limine-theme.conf` | top of `/boot/limine.conf` | Limine menu theme (wallpaper at `/boot/limine/wallpaper.jpg`) |
| `boot/limine/default-limine.snippet` | `/etc/default/limine` | Kernel options: `quiet splash` + the Catppuccin console palette |
| `boot/plymouth/` | `/usr/share/plymouth/themes/aurora`, `/etc/plymouth/` | "aurora" splash: Arch logo, pulsing dots, themed passphrase field |
| `boot/etc/` | `/etc/...` | initramfs hooks (plymouth before encrypt), console font, greetd-after-plymouth drop-in |

## Notes

- **Console palette.** The login runs on the Linux console, whose 16 colours
  come from `vt.default_*` on the kernel command line. Slot 0 is base
  `#1e1e2e`; slot 10 (normally a duplicate bright green) is crust `#11111b`,
  the only colour darker than the background, used for the banner's shadow.
  tuigreet's named colours map onto it (`lightmagenta` = mauve,
  `lightblue` = lavender).
- **Console font** is `ter-132b` (`terminus-font`). It must be a 256-glyph
  font: 512-glyph fonts cost the console its 8 bright colours. That font has
  no half-blocks, double or rounded box lines, so the decorations stick to
  `█ ▒ ░ · • + * ° ◆`.
- **Wallpapers aren't included.** Put yours at `/boot/limine/wallpaper.jpg`
  for Limine, and build the splash background with
  `boot/plymouth/make-background.sh ~/Pictures/Wallpapers/your.jpg`.
- **After changing boot files** rebuild with `sudo limine-mkinitcpio`.
- **Keeping this repo current:** `./sync.sh` copies the live files back in;
  review `git diff`, commit, push.
