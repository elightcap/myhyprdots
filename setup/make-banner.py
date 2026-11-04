#!/usr/bin/env python3
"""Writes a block-letter banner into greetd.toml's --greeting: solid █ letters
in a pastel gradient with a solid drop shadow, using only glyphs the
256-glyph Terminus console font has. Usage: ./make-banner.py [WORD]  (default HYPRLAND)
Letters available: those in FONT below; add more as 5 rows of 6 columns."""
import pathlib, re, sys

FONT = {
    'A': [" ████ ", "██  ██", "██████", "██  ██", "██  ██"],
    'D': ["█████ ", "██  ██", "██  ██", "██  ██", "█████ "],
    'H': ["██  ██", "██  ██", "██████", "██  ██", "██  ██"],
    'L': ["██    ", "██    ", "██    ", "██    ", "██████"],
    'N': ["██  ██", "███ ██", "██ ███", "██  ██", "██  ██"],
    'P': ["█████ ", "██  ██", "█████ ", "██    ", "██    "],
    'R': ["█████ ", "██  ██", "█████ ", "██ ██ ", "██  ██"],
    'Y': ["██  ██", "██  ██", " ████ ", "  ██  ", "  ██  "],
}
# SGR colours on the Catppuccin console palette, left to right, whole
# letters each: pink, mauve, lavender, blue. Use one entry for a solid colour
# (95 mauve, 94 lavender, 34 blue, 35 pink, 32 green, 33 yellow).
GRADIENT = [35, 95, 94, 34]
# Slot 10 (SGR 92) is set to Catppuccin crust (#11111b) on the kernel command
# line: the one colour darker than the base background, so it reads as shadow.
SHADOW = 92

word = (sys.argv[1] if len(sys.argv) > 1 else "HYPRLAND").upper()
missing = sorted(set(word) - set(FONT))
if missing:
    sys.exit(f"no glyph for: {' '.join(missing)}")

n = len(word)
W, H = n * 7, 6  # 6-wide letters + 1 gap; one extra row/col for the shadow


def colour(letter):
    """Whole letters per colour, swept left to right across GRADIENT."""
    return GRADIENT[letter * len(GRADIENT) // n]


grid = [[(" ", None)] * W for _ in range(H)]
for li, ch in enumerate(word):
    for y, row in enumerate(FONT[ch]):
        for x, c in enumerate(row):
            if c == "█":
                gx = li * 7 + x
                if grid[y + 1][gx + 1][0] == " ":
                    grid[y + 1][gx + 1] = ("█", SHADOW)
                grid[y][gx] = ("█", colour(li))

E = "\\u001b"  # TOML escape, becomes a real ESC when greetd reads the file
lines = []
for row in grid:
    out, cur = "", None
    for ch, col in row:
        if ch != " " and col != cur:
            out += f"{E}[{col}m"
            cur = col
        out += ch
    # 39 resets only the foreground; a full reset (0) would also drop the
    # login box's background colour.
    lines.append(out + f"{E}[39m")
greeting = "\\n".join(lines) + "\\n "  # trailing blank row before the prompts

toml = pathlib.Path(__file__).resolve().parent / "greetd.toml"
text = toml.read_text()
text, count = re.subn(r"--greeting '[^']*'", lambda _: f"--greeting '{greeting}'", text)
if count != 1:
    sys.exit("could not find --greeting '...' in greetd.toml")
toml.write_text(text)
for row in grid:
    print("".join(ch for ch, _ in row))
print(f"\nwrote {toml}; install with: sudo install -m644 {toml} /etc/greetd/config.toml")
