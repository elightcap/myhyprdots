-- hyprctl monitors lists what is connected. The Acer ultrawide is DP-1.
hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = "1" })

-- Anything else that gets plugged in goes to the right of it.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
