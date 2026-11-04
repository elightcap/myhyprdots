-- Apps don't get to maximize themselves; tiling decides.
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- Stop invisible XWayland drag helpers from taking focus.
hl.window_rule({
  name = "fix-xwayland-drags",
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

-- Terminal panels (audio, bluetooth, network, activity) float in the middle.
hl.window_rule({ name = "tui-panels", match = { class = "^tui\\.float$" }, float = true, size = "1100 700", center = true })

-- Small utility windows and file dialogs float too.
hl.window_rule({
  name = "float-utilities",
  match = { class = "^(org\\.pulseaudio\\.pavucontrol|nm-connection-editor|xdg-desktop-portal-gtk|com\\.gabm\\.satty|hyprland-share-picker)$" },
  float = true,
  center = true,
})
hl.window_rule({
  name = "float-dialogs",
  match = { title = "^(Open File|Open Files|Save File|Save As|Open Folder|Select a File|File Upload|Choose Files).*" },
  float = true,
  center = true,
})

-- Picture-in-picture video stays on top in a corner.
hl.window_rule({ name = "pip", match = { title = "^Picture.in.[Pp]icture$" }, float = true, pin = true, move = "monitor_w-560 monitor_h-340", size = "540 304" })

-- The wallpaper picker: wide enough for a big preview at the screen's shape.
hl.window_rule({ name = "wallpaper-picker", match = { class = "^wallpaper\\.picker$" }, float = true, size = "1700 600", center = true })

-- App homes: each app opens on its own workspace. SUPER + SHIFT + number still
-- moves anything anywhere afterwards.
local homes = {
  { name = "home-chat", workspace = "1", class = "^([Ss]lack|discord|vesktop)$" },
  { name = "home-browser", workspace = "2", class = "^firefox$" },
  { name = "home-code", workspace = "3", class = "^(VSCodium|codium|[Cc]ursor)$" },
  { name = "home-music", workspace = "4", class = "^[Ss]potify$" },
  -- Steam and its games, Heroic, Faugus and Vintage Story. Your own Godot
  -- builds are left wherever you run them.
  { name = "home-games", workspace = "5", class = "^(steam|steam_app_[0-9]+|steamwebhelper|[Hh]eroic|faugus-launcher|[Vv]intagestory)$" },
}
for _, home in ipairs(homes) do
  hl.window_rule({ name = home.name, match = { class = home.class }, workspace = home.workspace })
end
