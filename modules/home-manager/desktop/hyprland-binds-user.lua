-- User Hyprland keybind overrides loaded after DMS defaults.

local terminal = os.getenv("TERMINAL") or "kitty"
local floating_terminal = { float = true, size = { 1111, 700 }, center = true }

for _, key in ipairs({
	"SUPER + space",
	"SUPER + Space",
	"SUPER + SHIFT + E",
	"SUPER + P",
	"SUPER + W",
	"SUPER + SHIFT + W",
	"SUPER + X",
}) do
	hl.unbind(key)
end

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + Return", hl.dsp.exec_cmd(terminal, floating_terminal))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(terminal, { fullscreen = true }))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(terminal .. " -e yazi", floating_terminal))

hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox", { workspace = "1 silent" }))
hl.bind("SUPER + D", hl.dsp.exec_cmd("dms ipc launcher toggle"))
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("ALT + Escape", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exec_cmd("dms ipc powermenu toggle"))

hl.bind("SUPER + Space", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.resize({ x = 1111, y = 700 }))
	hl.dispatch(hl.dsp.window.center())
end)
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + X", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("dms ipc color-picker toggle"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("dms ipc wallpaper next"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc wallpaper prev"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("resources", { workspace = "11" }))
hl.bind("SUPER + F1", hl.dsp.exec_cmd("dms ipc keybinds toggle"))

hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
hl.bind("SUPER + CTRL + C", hl.dsp.window.move({ workspace = "empty" }))

hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("dms screenshot window"))
