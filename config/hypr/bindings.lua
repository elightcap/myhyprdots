-- Keybindings, laid out the way Omarchy had them. SUPER + K lists them all.
-- Each line reads: bind("KEYS", "What it does", action[, options]). An action
-- is a shell command (a string), a Hyprland dispatcher or a Lua function.

local scripts = os.getenv("HOME") .. "/.config/hypr/scripts"

local function bind(keys, description, action, options)
  local opts = options or {}
  opts.description = description
  if type(action) == "string" then
    action = hl.dsp.exec_cmd(action)
  end
  hl.bind(keys, action, opts)
end

local function panel(class, command)
  return "kitty --class " .. class .. " -e " .. command
end

-- Applications
bind("SUPER + RETURN", "Terminal", "kitty")
bind("SUPER + SPACE", "App launcher", scripts .. "/launcher")
bind("SUPER + SHIFT + RETURN", "Browser", "firefox")
bind("SUPER + SHIFT + B", "Browser", "firefox")
bind("SUPER + SHIFT + ALT + B", "Browser (private)", "firefox --private-window")
bind("SUPER + SHIFT + F", "File manager", "dolphin")
bind("SUPER + SHIFT + N", "Editor (Neovim)", "kitty -e nvim")
bind("SUPER + SHIFT + C", "Code editor (VSCodium)", "codium")
-- Spotify names its window only after it appears, too late for a window rule,
-- so its key sends it to workspace 4 at launch instead.
bind("SUPER + SHIFT + M", "Music", hl.dsp.exec_cmd("spotify", { workspace = "4" }))
bind("SUPER + SHIFT + G", "Signal", "signal-desktop")
bind("SUPER + SHIFT + SLASH", "Passwords", "1password")
bind("SUPER + SHIFT + T", "Activity (btop)", panel("tui.float", "btop"))

-- Panels
bind("SUPER + CTRL + A", "Audio", panel("tui.float", "wiremix"))
bind("SUPER + CTRL + B", "Bluetooth", panel("tui.float", "bluetui"))
bind("SUPER + CTRL + N", "Network", panel("tui.float", "nmtui"))
bind("SUPER + CTRL + V", "Clipboard history", scripts .. "/clipboard")
bind("SUPER + K", "Keybindings", scripts .. "/keybindings")
bind("SUPER + ESCAPE", "Power menu", scripts .. "/power-menu")
bind("XF86PowerOff", "Power menu", scripts .. "/power-menu")
bind("SUPER + CTRL + L", "Lock screen", "loginctl lock-session")
bind("SUPER + SHIFT + SPACE", "Toggle top bar", "pkill -SIGUSR1 waybar")
bind("SUPER + CTRL + SPACE", "Next wallpaper", scripts .. "/wallpaper next")
bind("SUPER + CTRL + W", "Wallpaper picker", scripts .. "/wallpaper-picker")

-- Notifications
bind("SUPER + COMMA", "Dismiss notification", "makoctl dismiss")
bind("SUPER + SHIFT + COMMA", "Dismiss all notifications", "makoctl dismiss --all")
bind("SUPER + ALT + COMMA", "Bring back last notification", "makoctl restore")
bind("SUPER + CTRL + COMMA", "Act on notification", "makoctl menu " .. scripts .. "/menu Action small")
bind("SUPER + CTRL + ALT + COMMA", "Toggle do not disturb", scripts .. "/dnd toggle")

-- Capture
bind("PRINT", "Screenshot region to clipboard and file", scripts .. "/screenshot region")
bind("SHIFT + PRINT", "Screenshot region and annotate", scripts .. "/screenshot edit")
bind("CTRL + PRINT", "Screenshot whole screen", scripts .. "/screenshot output")
bind("SUPER + PRINT", "Color picker", "hyprpicker -a")
bind("ALT + PRINT", "Screen recording (start / stop)", scripts .. "/screenrecord")

-- Windows
bind("SUPER + W", "Close window", hl.dsp.window.close())
bind("SUPER + Q", "Close window", hl.dsp.window.close())
bind("SUPER + T", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + ALT + F", "Full width (maximize)", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind("SUPER + J", "Toggle split direction", hl.dsp.layout("togglesplit"))
bind("SUPER + P", "Pseudo-tile window", hl.dsp.window.pseudo())

bind("SUPER + LEFT", "Focus left", hl.dsp.focus({ direction = "l" }))
bind("SUPER + RIGHT", "Focus right", hl.dsp.focus({ direction = "r" }))
bind("SUPER + UP", "Focus up", hl.dsp.focus({ direction = "u" }))
bind("SUPER + DOWN", "Focus down", hl.dsp.focus({ direction = "d" }))
bind("SUPER + SHIFT + LEFT", "Swap window left", hl.dsp.window.swap({ direction = "l" }))
bind("SUPER + SHIFT + RIGHT", "Swap window right", hl.dsp.window.swap({ direction = "r" }))
bind("SUPER + SHIFT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
bind("SUPER + SHIFT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
bind("ALT + TAB", "Next window", hl.dsp.window.cycle_next())
bind("ALT + TAB", "Raise it", hl.dsp.window.bring_to_top())
bind("ALT + SHIFT + TAB", "Previous window", hl.dsp.window.cycle_next({ next = false }))
bind("ALT + SHIFT + TAB", "Raise it", hl.dsp.window.bring_to_top())

-- Resize with SUPER + minus / equals (add SHIFT for height, ALT for small steps, CTRL for big ones)
for _, step in ipairs({ { "", 100, "" }, { "ALT + ", 25, " a little" }, { "CTRL + ", 300, " a lot" } }) do
  local mods, px, how = step[1], step[2], step[3]
  bind("SUPER + " .. mods .. "MINUS", "Wider" .. how, hl.dsp.window.resize({ x = -px, y = 0, relative = true }), { repeating = true })
  bind("SUPER + " .. mods .. "EQUAL", "Narrower" .. how, hl.dsp.window.resize({ x = px, y = 0, relative = true }), { repeating = true })
  bind("SUPER + SHIFT + " .. mods .. "MINUS", "Shorter" .. how, hl.dsp.window.resize({ x = 0, y = -px, relative = true }), { repeating = true })
  bind("SUPER + SHIFT + " .. mods .. "EQUAL", "Taller" .. how, hl.dsp.window.resize({ x = 0, y = px, relative = true }), { repeating = true })
end

-- Groups (tabbed windows)
bind("SUPER + G", "Toggle window group", hl.dsp.group.toggle())
bind("SUPER + ALT + G", "Take window out of group", hl.dsp.window.move({ out_of_group = true }))
bind("SUPER + ALT + LEFT", "Move window into group on left", hl.dsp.window.move({ into_group = "l" }))
bind("SUPER + ALT + RIGHT", "Move window into group on right", hl.dsp.window.move({ into_group = "r" }))
bind("SUPER + ALT + UP", "Move window into group above", hl.dsp.window.move({ into_group = "u" }))
bind("SUPER + ALT + DOWN", "Move window into group below", hl.dsp.window.move({ into_group = "d" }))
bind("SUPER + ALT + TAB", "Next window in group", hl.dsp.group.next())
bind("SUPER + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())

-- Workspaces. Key codes 10-19 are the number row, whatever the layout.
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }), { description = "Switch to workspace " .. workspace })
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }), { description = "Move window to workspace " .. workspace })
  hl.bind("SUPER + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }), { description = "Move window silently to workspace " .. workspace })
end
bind("SUPER + TAB", "Next workspace", hl.dsp.focus({ workspace = "m+1" }))
bind("SUPER + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "m-1" }))
bind("SUPER + CTRL + TAB", "Last workspace", hl.dsp.focus({ workspace = "previous_per_monitor" }))
bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
bind("SUPER + mouse_down", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + mouse_up", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse: SUPER + left drag moves, SUPER + right drag resizes
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Layout and look toggles
bind("SUPER + L", "Switch layout (dwindle / scrolling)", function()
  local layout = hl.get_config("general.layout")
  hl.config({ general = { layout = layout == "dwindle" and "scrolling" or "dwindle" } })
end)
bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", function()
  local gapless = hl.get_config("general.gaps_out") == 0
  hl.config({ general = { gaps_in = gapless and 5 or 0, gaps_out = gapless and 10 or 0 } })
end)
bind("SUPER + CTRL + Z", "Zoom in", function()
  hl.config({ cursor = { zoom_factor = (hl.get_config("cursor.zoom_factor") or 1) + 1 } })
end)
bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

-- Universal copy and paste: SUPER + C / V / X / A work in every app, the
-- terminal included, where they become CTRL + SHIFT + C / V.
local function press(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end
local function in_terminal()
  local window = hl.get_active_window()
  return window ~= nil and (window.class == "kitty" or window.class == "tui.float")
end
local function universal(key)
  return function()
    press(in_terminal() and "CTRL SHIFT" or "CTRL", key)()
  end
end
bind("SUPER + C", "Copy", universal("C"))
bind("SUPER + V", "Paste", universal("V"))
bind("SUPER + X", "Cut", press("CTRL", "X"))
bind("SUPER + A", "Select all", press("CTRL", "A"))

-- Media and volume keys, with an on-screen popup
local held = { locked = true, repeating = true }
bind("XF86AudioRaiseVolume", "Volume up", "swayosd-client --output-volume raise", held)
bind("XF86AudioLowerVolume", "Volume down", "swayosd-client --output-volume lower", held)
bind("XF86AudioMute", "Mute", "swayosd-client --output-volume mute-toggle", { locked = true })
bind("XF86AudioMicMute", "Mute microphone", "swayosd-client --input-volume mute-toggle", { locked = true })
bind("XF86MonBrightnessUp", "Brightness up", "swayosd-client --brightness raise", held)
bind("XF86MonBrightnessDown", "Brightness down", "swayosd-client --brightness lower", held)
bind("XF86AudioPlay", "Play / pause", "playerctl play-pause", { locked = true })
bind("XF86AudioPause", "Play / pause", "playerctl play-pause", { locked = true })
bind("XF86AudioNext", "Next track", "playerctl next", { locked = true })
bind("XF86AudioPrev", "Previous track", "playerctl previous", { locked = true })
