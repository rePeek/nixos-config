-- User Hyprland keybind overrides loaded after DMS defaults.

hl.bind("SUPER + Return", hl.dsp.exec_cmd(os.getenv("TERMINAL") or "kitty"))
hl.bind("ALT + Return", hl.dsp.exec_cmd("[float; size 1111 700] " .. (os.getenv("TERMINAL") or "kitty")))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("[fullscreen] " .. (os.getenv("TERMINAL") or "kitty")))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd([[hyprctl dispatch exec '[float; size 1111 700] ]] .. (os.getenv("TERMINAL") or "kitty") .. [[ -e yazi']]))

hl.bind("SUPER + B", hl.dsp.exec_cmd([[hyprctl dispatch exec '[workspace 1 silent] firefox']]))
hl.bind("SUPER + D", hl.dsp.exec_cmd("dms ipc launcher toggle"))
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("ALT + Escape", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exec_cmd("dms ipc powermenu toggle"))

hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl dispatch togglefloating && hyprctl dispatch resizeactive exact 1111 700 && hyprctl dispatch centerwindow"))
hl.bind("SUPER + P", hl.dsp.layout("pseudo"))
hl.bind("SUPER + X", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("dms ipc color-picker toggle"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("dms ipc wallpaper next"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc wallpaper prev"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd([[hyprctl dispatch exec '[workspace 11] resources']]))
hl.bind("SUPER + F1", hl.dsp.exec_cmd("dms ipc keybinds toggle"))

hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
hl.bind("SUPER + CTRL + C", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace empty"))

hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("dms screenshot window"))
