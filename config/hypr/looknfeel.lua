local c = require("hypr.colors")

local function rgba(hex, alpha)
  return "rgba(" .. hex .. (alpha or "ff") .. ")"
end

local active_border = { colors = { rgba(c.blue, "ee"), rgba(c.mauve, "ee") }, angle = 45 }
local inactive_border = rgba(c.surface1, "aa")

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col = { active_border = active_border, inactive_border = inactive_border },
    resize_on_border = true,
    extend_border_grab_area = 8,
    hover_icon_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 10,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = { enabled = true, range = 12, render_power = 3, color = 0x6611111b },
    blur = { enabled = true, size = 6, passes = 2, vibrancy = 0.17 },
  },
  group = {
    col = { border_active = active_border, border_inactive = inactive_border },
    groupbar = {
      font_size = 12,
      font_family = "CaskaydiaMono Nerd Font",
      height = 22,
      indicator_height = 0,
      gradients = true,
      gradient_rounding = 6,
      text_color = rgba(c.base),
      text_color_inactive = rgba(c.text),
      col = { active = rgba(c.blue), inactive = rgba(c.surface0) },
    },
  },
  animations = { enabled = true },
  dwindle = { preserve_split = true, force_split = 2 },
  scrolling = { column_width = 0.49 },
  master = { new_status = "master" },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    background_color = rgba(c.crust),
    focus_on_activate = true,
    anr_missed_pings = 3,
    allow_session_lock_restore = true,
  },
  cursor = { hide_on_key_press = true, warp_on_change_workspace = 1 },
  binds = { hide_special_on_workspace_change = true },
})

-- Hyprland's own default motion, which is smooth without being slow.
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Blur behind the bar, launcher, notifications and volume popups.
hl.layer_rule({
  name = "blur-shell",
  match = { namespace = "^(waybar|rofi|launcher|notifications|swayosd)$" },
  blur = true,
  ignore_alpha = 0.2,
})
