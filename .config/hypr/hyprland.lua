local launch_app = "uwsm app -- "
local browser = "firefox"
local mail = "electron-mail"
local menu = "hyprlauncher"
local notif = "dunst"
local terminal = "ghostty"

--------------------------------------------------------------------------------
-- Monitors
--------------------------------------------------------------------------------
hl.monitor({ -- Desktop
	output = "DP-1",
	mode = "highres@highrr",
	position = "auto",
	scale = "1",
})
hl.monitor({ -- Laptop
	output = "eDP-1",
	mode = "highres@highrr",
	position = "auto",
	scale = "1.5",
})
hl.monitor({ -- Extend monitor
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

--------------------------------------------------------------------------------
-- Autostart
--------------------------------------------------------------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd(launch_app .. browser)
	hl.exec_cmd(launch_app .. notif)
	hl.exec_cmd(launch_app .. "kdeconnect-indicator")
	hl.exec_cmd(launch_app .. mail)
	hl.exec_cmd(launch_app .. menu .. " -d")
	hl.exec_cmd(launch_app .. "nm-applet")
	hl.exec_cmd(launch_app .. "vesktop")
	hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
end)

--------------------------------------------------------------------------------
-- Look & Feel
--------------------------------------------------------------------------------
hl.config({
	general = {
		gaps_out = {
			top = 0,
			right = 20,
			bottom = 20,
			left = 20,
		},
		layout = "master",
	},
	decoration = {
		rounding = 10,
		active_opacity = 0.9,
		inactive_opacity = 0.6,
	},
	input = {
		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.3,
		},
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
	dwindle = {
		preserve_split = true,
	},
})

--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------
-- General
local main_mod = "SUPER"
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(launch_app .. browser), { description = "Launch " .. browser })
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | ksnip -'), { description = "Screenshot" })
hl.bind(
	main_mod .. " + CTRL + R",
	hl.dsp.exec_cmd(
		"systemctl --user restart waybar && dunstctl reload && pkill " .. menu .. " && " .. launch_app .. menu .. " -d"
	),
	{ description = "Reload waybar, " .. notif .. ", " .. menu }
)
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(launch_app .. menu), { description = "Launch " .. menu })
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(launch_app .. terminal), { description = "Launch " .. terminal })
hl.bind(main_mod .. " + W", hl.dsp.window.close(), { description = "Close window" })

-- Notifications
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("dunstctl close"), { description = "Close topmost notification" })
hl.bind(
	main_mod .. " + SHIFT + N",
	hl.dsp.exec_cmd(
		[[dunstctl history | jq -r '.data[0][] | "\(.id.data)| \(.summary.data) \(.body.data)"' | column -t -s '|' | hyprlauncher --dmenu | awk '{system("dunstctl history-pop " $1)}']]
	),
	{ description = "Launch notification history" }
)
hl.bind(
	main_mod .. " + R",
	hl.dsp.exec_cmd("dunstctl context"),
	{ description = "Launch context menu for notifications" }
)

-- Layout Control
hl.bind("SUPER + tab", function() -- Cycle layouts
	local layouts = { "scrolling", "dwindle", "master", "monocle" }
	local workspace = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

	local next_layout = "dwindle"

	if not workspace then
		return
	end

	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
	hl.notification.create({ text = next_layout, timeout = 2000 })
end, { description = "Cycle layouts" })
hl.bind(main_mod .. " + M", function()
	if hl.get_active_workspace().tiled_layout == "master" then
		hl.dispatch(hl.dsp.layout("swapwithmaster"))
	end
end, { description = "Swap window with master (Master)" })
hl.bind(main_mod .. " + CTRL + N", function()
	if hl.get_active_workspace().tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cyclenext"))
	end
end, { description = "Cycle to next window (Monocle)" })
hl.bind(main_mod .. " + CTRL + P", function()
	if hl.get_active_workspace().tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cycleprev"))
	end
end, { description = "Cycle to previous window (Monocle)" })

-- Opacity Control, and draw as little power as possible
local is_transparent = true
hl.bind(main_mod .. " + O", function()
	hl.config({
		decoration = {
			shadow = { enabled = not is_transparent },
			blur = { enabled = not is_transparent },
			active_opacity = is_transparent and 1.0 or 0.9,
			inactive_opacity = is_transparent and 1.0 or 0.9,
		},
	})
	is_transparent = not is_transparent
end, { description = "Toggle transparency and draw as little power as possible" })

-- Move Focus Inside Workspace
hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })

-- Move Window Inside Worspace
hl.bind(
	main_mod .. " + CTRL + H",
	hl.dsp.window.move({ direction = "left", relative = true }),
	{ repeating = true, description = "Move window left" }
)
hl.bind(
	main_mod .. " + CTRL + J",
	hl.dsp.window.move({ direction = "down", relative = true }),
	{ repeating = true, description = "Move window down" }
)
hl.bind(
	main_mod .. " + CTRL + K",
	hl.dsp.window.move({ direction = "up", relative = true }),
	{ repeating = true, description = "Move window up" }
)
hl.bind(
	main_mod .. " + CTRL + L",
	hl.dsp.window.move({ direction = "right", relative = true }),
	{ repeating = true, description = "Move window right" }
)
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window (Mouse)" })

-- Move Focus/Window To Workspace
for i = 1, 10 do
	local key = i % 10
	hl.bind(
		main_mod .. " + " .. key,
		hl.dsp.focus({ workspace = i }),
		{ description = "Move focus to workspace " .. key }
	)
	hl.bind(
		main_mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. key }
	)
end

-- Resize Window
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize window" })
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle window float" })
hl.bind(
	main_mod .. " + SHIFT + H",
	hl.dsp.window.resize({ x = -50, y = 0, relative = true }),
	{ repeating = true, description = "Resize window leftward" }
)
hl.bind(
	main_mod .. " + SHIFT + J",
	hl.dsp.window.resize({ x = 0, y = 50, relative = true }),
	{ repeating = true, description = "Resize window downward" }
)
hl.bind(
	main_mod .. " + SHIFT + K",
	hl.dsp.window.resize({ x = 0, y = -50, relative = true }),
	{ repeating = true, description = "Resize window upward" }
)
hl.bind(
	main_mod .. " + SHIFT + L",
	hl.dsp.window.resize({ x = 50, y = 0, relative = true }),
	{ repeating = true, description = "Resize window rightward" }
)
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window (Mouse)" })

-- Volume
local vol_cmd_template =
	[[ && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{if ($3) system("dunstify \"Volume Muted\" --app-name=vol_and_bright -u low --icon audio-volume-muted-symbolic --stack-tag VOL -h int:value:" int($2*100)); else system("dunstify Volume --app-name=vol_and_bright -u low --icon %s --stack-tag VOL -h int:value:" int($2*100))}']]
local vol_binds = {
	{
		action = "Raise",
		bind = "XF86AudioRaiseVolume",
		cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
		icon = "audio-volume-high-symbolic ",
	},
	{
		action = "Lower",
		bind = "XF86AudioLowerVolume",
		cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
		icon = "audio-volume-low-symbolic ",
	},
	{
		action = "Mute",
		bind = "XF86AudioMute",
		cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
		icon = "audio-volume-high-symbolic ",
	},
}
for _, vol_bind in ipairs(vol_binds) do
	local formatted_cmd = string.format(vol_cmd_template, vol_bind.icon)
	local final_cmd = vol_bind.cmd .. formatted_cmd
	hl.bind(vol_bind.bind, hl.dsp.exec_cmd(final_cmd), { repeating = true, description = vol_bind.action .. " volume" })
end

-- Brightness
local brightness_cmd_template =
	" && dunstify Brightness --app-name=vol_and_bright -u low --icon xfpm-brightness-lcd --stack-tag BRIGHTNESS -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) ))"
local brightness_binds = {
	{
		action = "Increase",
		bind = "XF86MonBrightnessUp",
		cmd = "brightnessctl -e4 -n2 set 5%+",
	},
	{
		action = "Decrease",
		bind = "XF86MonBrightnessDown",
		cmd = "brightnessctl -e4 -n2 set 5%-",
	},
}
for _, brightness_bind in ipairs(brightness_binds) do
	local final_cmd = brightness_bind.cmd .. brightness_cmd_template
	hl.bind(
		brightness_bind.bind,
		hl.dsp.exec_cmd(final_cmd),
		{ repeating = true, description = brightness_bind.action .. " brightness" }
	)
end

-- Zoom
local MAX_ZOOM = 100
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1
---@param offset number
---@return nil
local function zoom(offset)
	local current = hl.get_config("cursor.zoom_factor")
	if offset ~= nil then
		current = current + offset
	elseif current ~= MIN_ZOOM then
		current = MIN_ZOOM
	else
		current = ZOOM_TOGGLE_FACTOR
	end
	current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
	hl.config({ cursor = { zoom_factor = current } })
end
hl.bind(main_mod .. " + Z", zoom, { description = "Toggle zoom" })
hl.bind(main_mod .. " + mouse_down", function()
	zoom(0.5)
end, { description = "Zoom in (Scroll wheel)" })
hl.bind(main_mod .. " + code:21", function()
	zoom(0.5)
end, { repeating = true, description = "Zoom in (Keyboard)" })
hl.bind(main_mod .. " + mouse_up", function()
	zoom(-0.5)
end, { description = "Zoom out (Scrool wheel)" })
hl.bind(main_mod .. " + code:20", function()
	zoom(-0.5)
end, { repeating = true, description = "Zoom out (Keyboard)" })
hl.gesture({ fingers = 2, mods = main_mod, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

-- OBS
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("obs-cmd recording toggle"), { description = "OBS toggle recording" })
hl.bind(
	"CTRL + SHIFT + P",
	hl.dsp.exec_cmd("obs-cmd recording toggle-pause"),
	{ description = "OBS toggle pause recording" }
)

-- Keybind Help
hl.bind(
	main_mod .. " + code:61",
	hl.dsp.exec_cmd([[
        hyprctl -j binds | 
        jq -r '.[] | 
        ([
            (if (.modmask % 128 / 64 | floor) == 1 then "SUPER" else empty end),
            (if (.modmask % 16 / 8) | floor == 1 then "ALT" else empty end),
            (if (.modmask % 8 / 4 | floor) == 1 then "CTRL" else empty end),
            (if (.modmask % 2 / 1 | floor) == 1 then "SHIFT" else empty end)
        ] | join("+")) as $mods |
        "\(if $mods != "" then $mods + "+" else "" end)\(.key)| \(.description)"' |
        column -t -s '|' |
        hyprlauncher --dmenu
        ]]),
	{ description = "Keybind help" }
)

--------------------------------------------------------------------------------
-- Window Rules
--------------------------------------------------------------------------------
hl.window_rule({
	match = { class = "org.kde.kdeconnect.*" },
	float = true,
})
hl.window_rule({
	match = { class = "vesktop" },
	workspace = "2 silent",
})
hl.window_rule({
	match = { class = mail },
	workspace = "3 silent",
})
