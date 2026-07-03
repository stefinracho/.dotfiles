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
	hl.exec_cmd(launch_app .. mail)
	hl.exec_cmd(launch_app .. "nm-applet")
	hl.exec_cmd(launch_app .. notif)
	hl.exec_cmd(launch_app .. "vesktop")
end)
hl.window_rule({
	match = { class = browser },
	workspace = "1",
})
hl.window_rule({
	match = { class = "vesktop" },
	workspace = "2 silent",
})
hl.window_rule({
	match = { class = mail },
	workspace = "3 silent",
})

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
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(launch_app .. browser))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(launch_app .. menu))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(launch_app .. terminal))
hl.bind(main_mod .. " + W", hl.dsp.window.close())
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd("systemctl --user restart waybar && dunstctl reload && pkill hyprlauncher"))
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | ksnip -'))

-- Layout Control
hl.bind("SUPER + tab", function() -- Cycle through layouts
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
end)
hl.bind(main_mod .. " + M", function()
	if hl.get_active_workspace().tiled_layout == "master" then
		hl.dispatch(hl.dsp.layout("swapwithmaster"))
	end
end)
hl.bind(main_mod .. " + CTRL + N", function()
	if hl.get_active_workspace().tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cyclenext"))
	end
end)
hl.bind(main_mod .. " + CTRL + P", function()
	if hl.get_active_workspace().tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cycleprev"))
	end
end)

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
end)

-- Move Focus Inside Workspace
hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move Window Inside Worspace
hl.bind(main_mod .. " + CTRL + H", hl.dsp.window.move({ direction = "left", relative = true }))
hl.bind(main_mod .. " + CTRL + J", hl.dsp.window.move({ direction = "down", relative = true }))
hl.bind(main_mod .. " + CTRL + K", hl.dsp.window.move({ direction = "up", relative = true }))
hl.bind(main_mod .. " + CTRL + L", hl.dsp.window.move({ direction = "right", relative = true }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- Move Focus/Window To Workspace
for i = 1, 10 do
	local key = i % 10
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Resize Window
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + SHIFT + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume
local vol_cmd_template =
	' && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \'{if ($3) system("dunstify \\"Volume Muted\\" -u low --icon audio-volume-muted-symbolic --stack-tag VOL -h int:value:" int($2*100)); else system("dunstify Volume -u low --icon %s --stack-tag VOL -h int:value:" int($2*100))}\''
local vol_binds = {
	{
		bind = "XF86AudioRaiseVolume",
		cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
		icon = "audio-volume-high-symbolic ",
	},
	{
		bind = "XF86AudioLowerVolume",
		cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
		icon = "audio-volume-low-symbolic ",
	},
	{
		bind = "XF86AudioMute",
		cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
		icon = "audio-volume-high-symbolic ",
	},
}
for _, vol_bind in ipairs(vol_binds) do
	local formatted_cmd = string.format(vol_cmd_template, vol_bind.icon)
	local final_cmd = vol_bind.cmd .. formatted_cmd
	hl.bind(vol_bind.bind, hl.dsp.exec_cmd(final_cmd), { repeating = true })
end

-- Brightness
local brightness_cmd_template =
	" && dunstify Brightness -u low --icon xfpm-brightness-lcd --stack-tag BRIGHTNESS -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) ))"
local brightness_binds = {
	{
		bind = "XF86MonBrightnessUp",
		cmd = "brightnessctl -e4 -n2 set 5%+",
	},
	{
		bind = "XF86MonBrightnessDown",
		cmd = "brightnessctl -e4 -n2 set 5%-",
	},
}
for _, brightness_bind in ipairs(brightness_binds) do
	local final_cmd = brightness_bind.cmd .. brightness_cmd_template
	hl.bind(brightness_bind.bind, hl.dsp.exec_cmd(final_cmd), { repeating = true })
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
hl.bind(main_mod .. " + Z", zoom)
hl.bind(main_mod .. " + mouse_down", function()
	zoom(0.5)
end)
hl.bind(main_mod .. " + code:21", function()
	zoom(0.5)
end, { repeating = true })
hl.bind(main_mod .. " + mouse_up", function()
	zoom(-0.5)
end)
hl.bind(main_mod .. " + code:20", function()
	zoom(-0.5)
end, { repeating = true })
hl.gesture({ fingers = 2, mods = main_mod, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

-- OBS
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("obs-cmd recording toggle"))
hl.bind("CTRL + SHIFT + P", hl.dsp.exec_cmd("obs-cmd recording toggle-pause"))
