hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "hyprlauncher"
hl.on("hyprland.start", function()
	hl.exec_cmd("wireplumber")
	hl.exec_cmd("pipewire")
	hl.exec_cmd("qs")
	hl.exec_cmd("swaybg -i ~/Downloads/tahoe.jpg")
end)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,
		-- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = false,
	},
})
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
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
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})
hl.config({
	master = {
		new_status = "master",
	},
})
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})
hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})
hl.config({
	layers = {
		allow_new_top_layers_over_existing_fullscreen = true, -- Set to false to make newly mapped top layers render below existing covering fullscreen window
	},
})
hl.config({
	input = {
		repeat_delay = 200,
		repeat_rate = 35,
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = false,
		},
	},
})
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + D", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 1 })) -- dwindle only
local function focusAndRaise(dir)
	return function()
		-- 1. Jalankan perintah pindah fokus
		hl.dispatch(hl.dsp.focus({ direction = dir }))
		-- 2. Jalankan perintah menaikkan jendela aktif ke atas tumpukan z-index
		hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
	end
end
hl.bind(mainMod .. " + H", focusAndRaise("left"))
hl.bind(mainMod .. " + L", focusAndRaise("right"))
--hl.bind(mainMod .. " + K", focusAndRaise("up"))
--hl.bind(mainMod .. " + J", focusAndRaise("down"))
hl.bind(mainMod .. " + J", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ workspace = "-1" }))
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})
hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})
hl.window_rule({
	match = { class = ".*" },
	float = true,
})
hl.window_rule({
	match = { class = "firefox" },
	float = true,
	size = "1200 800",
})
hl.window_rule({
	match = { class = "kitty" },
	float = true,
	size = "1000 600",
})
