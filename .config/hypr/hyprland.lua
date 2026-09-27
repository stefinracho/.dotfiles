--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

local LAUNCH_APP <const> = "uwsm app -- "
local BROWSER <const> = "firefox"
local COLOR_PICKER <const> = "hyprpicker"
local MAIL <const> = "electron-mail"
local MENU <const> = "hyprlauncher"
local NOTIF <const> = "dunst"
local TERM <const> = "ghostty"

local OPAQUE_OPACITY <const> = 1.0
local ACTIVE_OPACITY <const> = 0.95
local INACTIVE_OPACITY <const> = 0.85

local GAPS_OUT <const> = 8
local GAPS_IN <const> = 4
local GAPS_ZERO <const> = 0

local ROUNDING <const> = 8

local MAIN_MOD <const> = "SUPER"

local reload_services = hl.dsp.exec_cmd(
	"systemctl --user restart hyprpaper.service dunstctl reload && pkill "
		.. MENU
		.. " && "
		.. LAUNCH_APP
		.. MENU
		.. " -d"
)

--------------------------------------------------------------------------------
-- Monitors
--------------------------------------------------------------------------------
local mon_mode = "highres@highrr"
local sec_mon_output = "HDMI-A-1"
local sec_mon_position = "0x0"
local sec_mon_scale = 3
local sec_mon_disabled = false

hl.monitor({
	output = sec_mon_output,
	mode = mon_mode,
	position = sec_mon_position,
	scale = sec_mon_scale,
})
hl.monitor({
	output = "DP-2",
	mode = mon_mode,
	scale = 1,
})
hl.monitor({ -- Laptop
	output = "eDP-1",
	mode = mon_mode,
	scale = 1.5,
})

hl.bind(MAIN_MOD .. " + M", function()
	if sec_mon_disabled then
		hl.monitor({
			output = sec_mon_output,
			mode = mon_mode,
			position = sec_mon_position,
			scale = sec_mon_scale,
			disabled = not sec_mon_disabled,
		})
		sec_mon_disabled = not sec_mon_disabled
	else
		hl.monitor({
			output = sec_mon_output,
			disabled = not sec_mon_disabled,
		})
		sec_mon_disabled = not sec_mon_disabled
	end

	hl.dispatch(reload_services)
end)

--------------------------------------------------------------------------------
-- Autostart
--------------------------------------------------------------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd(LAUNCH_APP .. BROWSER)
	hl.exec_cmd(LAUNCH_APP .. NOTIF)
	hl.exec_cmd(LAUNCH_APP .. "kdeconnect-indicator")
	hl.exec_cmd(LAUNCH_APP .. MAIL)
	hl.exec_cmd(LAUNCH_APP .. MENU .. " -d")
	hl.exec_cmd(LAUNCH_APP .. "quickshell")
	hl.exec_cmd(LAUNCH_APP .. "nm-applet")
	hl.exec_cmd(LAUNCH_APP .. "vesktop")
	hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
end)

--------------------------------------------------------------------------------
-- Look & Feel
--------------------------------------------------------------------------------
hl.config({
	general = {
		gaps_out = {
			top = GAPS_OUT,
			right = GAPS_OUT,
			bottom = GAPS_OUT,
			left = GAPS_OUT,
		},
		gaps_in = {
			top = GAPS_IN,
			right = GAPS_IN,
			bottom = GAPS_IN,
			left = GAPS_IN,
		},
		layout = "master",
	},
	decoration = {
		rounding = ROUNDING,
		active_opacity = ACTIVE_OPACITY,
		inactive_opacity = INACTIVE_OPACITY,
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
hl.bind(MAIN_MOD .. " + SPACE", hl.dsp.exec_cmd(LAUNCH_APP .. MENU), { description = "App launcher (" .. MENU .. ")" })
hl.bind(
	MAIN_MOD .. " + ESCAPE",
	hl.dsp.exec_cmd('echo -e "Suspend\nReboot\nShutdown" | ' .. MENU .. [[ --dmenu | 
    { read -r selection; case "$selection" in
    Suspend) systemctl suspend;;
    Reboot) hyprshutdown -t 'Rebooting...' --post-cmd 'reboot';;
    Shutdown) hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -h now';; 
    esac }]]),
	{ description = "Power options" }
)
hl.bind(MAIN_MOD .. " + Q", hl.dsp.window.close(), { description = "(Q)uit application" })
hl.bind(MAIN_MOD .. " + B", hl.dsp.exec_cmd(LAUNCH_APP .. BROWSER), { description = "(B)rowser (" .. BROWSER .. ")" })
hl.bind(MAIN_MOD .. " + G", hl.dsp.exec_cmd(LAUNCH_APP .. TERM), { description = "(G)hostty (terminal)" })
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | ksnip -'), { description = "Screenshot" })
hl.bind(
	MAIN_MOD .. " + C",
	hl.dsp.exec_cmd(LAUNCH_APP .. COLOR_PICKER .. " -an"),
	{ description = "(C)olor picker (" .. COLOR_PICKER .. ")" }
)

hl.bind(
	MAIN_MOD .. " + CTRL + R",
	reload_services,
	{ description = "(R)eload " .. NOTIF .. ", " .. MENU .. ", and other services" }
)

-- Track Time
hl.bind(
	MAIN_MOD .. " + T",
	hl.dsp.exec_cmd([[
            tags_all=()
            tags_all_count=$(timew get dom.tags.count)
            for ((i = 1; i <= tags_all_count; i++)); do
                tags_all[i]=$(timew get dom.tags."$i")
            done
            chosen_tag_all=$(printf "%s\n" "${tags_all[@]}" | ]] .. MENU .. [[ --dmenu)
            if [ -z "$chosen_tag_all" ] || [ "$chosen_tag_all" = "Exited without selection" ]; then
                exit 0
            fi
            timew start "$chosen_tag_all"
            quickshell ipc call timetracker refresh
            msg="Started tracking $chosen_tag_all"
            dunstify Timewarrior "$msg" --app-name time_track -u low --stack-tag time_track_tag_start]]),
	{ description = "Track Time: Start" }
)
hl.bind(
	MAIN_MOD .. " + SHIFT + T",
	hl.dsp.exec_cmd([[
            tags_active=()
            tags_active_count=$(timew get dom.active.tags.count)
            for ((i = 1; i <= tags_active_count; i++)); do
                tags_active[i]=$(timew get dom.active.tags."$i")
            done
            chosen_tag_active=$(printf "%s\n" "${tags_active[@]}" | ]] .. MENU .. [[ --dmenu)
            if [ -z "$chosen_tag_active" ] || [ "$chosen_tag_active" = "Exited without selection" ]; then
                exit 0
            fi
            timew stop "$chosen_tag_active"
            quickshell ipc call timetracker refresh
            interval_duration=$(timew summary @1 | tail -2 | head -1 | awk "{print $NF}" | xargs)
            today_total=$(timew summary "$chosen_tag_active" | tail -2 | head -1 | awk "{print $NF}" | xargs)
            msg="Stopped tracking ${chosen_tag_active}\n\nInterval: ${interval_duration}\nToday: ${today_total}"
            dunstify Timewarrior "$msg" --app-name time_track -u low --stack-tag time_track_tag_stop]]),
	{ description = "Track Time: Stop" }
)
hl.bind(
	MAIN_MOD .. " + CTRL + T",
	hl.dsp.exec_cmd([[
            active_duration=$(timew get dom.active.duration | sed 's/.*T//')
            [ -z "$active_duration" ] && exit 0
            active_tags=$(timew get dom.active.tags)
            msg="${active_tags} duration: ${active_duration}"
            dunstify Timewarrior "$msg" --app-name time_track -u low --stack-tag time_track_tag_duration]]),
	{ description = "Track Time: Active Duration" }
)
hl.bind(
	MAIN_MOD .. " + ALT + T",
	hl.dsp.exec_cmd([=[
            tags_all=()
            tags_all_count=$(timew get dom.tags.count)
            for ((i = 1; i <= tags_all_count; i++)); do
                tags_all[i]="$(timew get dom.tags."$i")"
            done
            msg="Today's Summary\n\n"
            for tag in "${tags_all[@]}"
            do
                tag_total=$(timew summary "$tag" | tail -2 | head -1 | awk "{print $NF}" | xargs)
                if [[ "$tag_total" == *"No filtered data"* ]]; then continue; fi
                msg+="${tag}: ${tag_total}\n"
            done
            dunstify Timewarrior "$msg" --app-name time_track -u low --stack-tag time_track_tag_summary]=]),
	{ description = "Track Time: Summary" }
)

-- Notifications
hl.bind(
	MAIN_MOD .. " + N",
	hl.dsp.exec_cmd("dunstctl close"),
	{ description = "Notifications: Close topmost notification" }
)
hl.bind(
	MAIN_MOD .. " + SHIFT + N",
	hl.dsp.exec_cmd([[
        NOTIF=$(dunstctl history | \
            jq -r '.data[0][] | "\(.id.data)| \(.summary.data) \(.body.data | gsub("\n"; " "))"' | \
            column -t -s '|' | \
             hyprlauncher --dmenu)
        [ -z "$NOTIF" ] && exit 0
        NOTIF_ID=$(echo "$NOTIF" | awk '{print $1}')
        dunstctl history-pop "$NOTIF_ID"
    ]]),
	{ description = "Notifications: Open history" }
)
hl.bind(MAIN_MOD .. " + A", hl.dsp.exec_cmd("dunstctl context"), { description = "Notifications: Take (A)ction" })

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
hl.bind(MAIN_MOD .. " + SHIFT + M", function()
	if hl.get_active_workspace().tiled_layout == "master" then
		hl.dispatch(hl.dsp.layout("swapwithmaster"))
	end
end, { description = "Swap window with master (Master)" })
hl.bind(MAIN_MOD .. " + CTRL + N", function()
	if hl.get_active_workspace().tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cyclenext"))
	end
end, { description = "Cycle to next window (Monocle)" })
hl.bind(MAIN_MOD .. " + CTRL + P", function()
	if hl.get_active_workspace().tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cycleprev"))
	end
end, { description = "Cycle to previous window (Monocle)" })

-- Opacity Control, and draw as little power as possible
local is_opaque = false
hl.bind(MAIN_MOD .. " + O", function()
	hl.config({
		decoration = {
			shadow = { enabled = is_opaque },
			blur = { enabled = is_opaque },
			active_opacity = is_opaque and ACTIVE_OPACITY or OPAQUE_OPACITY,
			inactive_opacity = is_opaque and INACTIVE_OPACITY or OPAQUE_OPACITY,
		},
	})
	is_opaque = not is_opaque
end, { description = "Toggle transparency and draw as little power as possible" })

-- Move Focus Inside Workspace
hl.bind(MAIN_MOD .. " + H", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(MAIN_MOD .. " + J", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })
hl.bind(MAIN_MOD .. " + K", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(MAIN_MOD .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })

-- Move Window Inside Worspace
hl.bind(
	MAIN_MOD .. " + CTRL + H",
	hl.dsp.window.move({ direction = "left", relative = true }),
	{ repeating = true, description = "Move window left" }
)
hl.bind(
	MAIN_MOD .. " + CTRL + J",
	hl.dsp.window.move({ direction = "down", relative = true }),
	{ repeating = true, description = "Move window down" }
)
hl.bind(
	MAIN_MOD .. " + CTRL + K",
	hl.dsp.window.move({ direction = "up", relative = true }),
	{ repeating = true, description = "Move window up" }
)
hl.bind(
	MAIN_MOD .. " + CTRL + L",
	hl.dsp.window.move({ direction = "right", relative = true }),
	{ repeating = true, description = "Move window right" }
)
hl.bind(MAIN_MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window (Mouse)" })

-- Move Focus/Window To Workspace
for i = 1, 10 do
	local key = i % 10
	hl.bind(
		MAIN_MOD .. " + " .. key,
		hl.dsp.focus({ workspace = i }),
		{ description = "Move focus to workspace " .. key }
	)
	hl.bind(
		MAIN_MOD .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. key }
	)
end

-- Resize Window
hl.bind(MAIN_MOD .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize window" })
hl.bind(
	MAIN_MOD .. " + CTRL + F",
	hl.dsp.window.fullscreen_state({
		internal = 0,
		client = 2,
		action = "toggle",
	}),
	{ description = "Fullscreen client, not window" }
)
hl.bind(MAIN_MOD .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }), { description = "Float window" })
hl.bind(
	MAIN_MOD .. " + SHIFT + H",
	hl.dsp.window.resize({ x = -50, y = 0, relative = true }),
	{ repeating = true, description = "Resize window leftward" }
)
hl.bind(
	MAIN_MOD .. " + SHIFT + J",
	hl.dsp.window.resize({ x = 0, y = 50, relative = true }),
	{ repeating = true, description = "Resize window downward" }
)
hl.bind(
	MAIN_MOD .. " + SHIFT + K",
	hl.dsp.window.resize({ x = 0, y = -50, relative = true }),
	{ repeating = true, description = "Resize window upward" }
)
hl.bind(
	MAIN_MOD .. " + SHIFT + L",
	hl.dsp.window.resize({ x = 50, y = 0, relative = true }),
	{ repeating = true, description = "Resize window rightward" }
)
hl.bind(MAIN_MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window (Mouse)" })

-- Window Gaps
local is_gapped = true
hl.bind(MAIN_MOD .. " + ALT + G", function()
	hl.config({
		general = {
			gaps_out = {
				top = is_gapped and GAPS_ZERO or GAPS_OUT,
				right = is_gapped and GAPS_ZERO or GAPS_OUT,
				bottom = is_gapped and GAPS_ZERO or GAPS_OUT,
				left = is_gapped and GAPS_ZERO or GAPS_OUT,
			},
			gaps_in = {
				top = is_gapped and GAPS_ZERO or GAPS_IN,
				right = is_gapped and GAPS_ZERO or GAPS_IN,
				bottom = is_gapped and GAPS_ZERO or GAPS_IN,
				left = is_gapped and GAPS_ZERO or GAPS_IN,
			},
		},
		decoration = {
			rounding = is_gapped and 0 or ROUNDING,
		},
	})
	is_gapped = not is_gapped
end, { description = "Gap windows" })

-- Bar
hl.bind(MAIN_MOD .. " + ALT + B", hl.dsp.exec_cmd("quickshell ipc call bar toggle"), { description = "Toggle Bar" })

-- Border
local border = true
hl.bind(MAIN_MOD .. " + CTRL + B", function()
	hl.config({
		general = {
			border_size = border and 0 or 1,
		},
	})
	border = not border
end, { description = "Toggle border" })

-- Volume
local vol_cmd_template = [[
    VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}');
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'; then
        dunstify "Volume Muted" --app-name vol_and_bright -u low --icon audio-volume-muted-symbolic --stack-tag vol_tag -h int:value:"$VOL";
    else
        dunstify "Volume" --app-name vol_and_bright -u low --icon %s --stack-tag vol_tag -h int:value:"$VOL";
    fi ]]
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
		icon = "audio-volume-high-symbolic",
	},
}
for _, vol_bind in ipairs(vol_binds) do
	local formatted_cmd = string.format(vol_cmd_template, vol_bind.icon)
	local final_cmd = vol_bind.cmd .. "; " .. formatted_cmd
	hl.bind(vol_bind.bind, hl.dsp.exec_cmd(final_cmd), { repeating = true, description = vol_bind.action .. " volume" })
end

-- Brightness
local brightness_cmd_template = [[ &&
    dunstify Brightness \
    --app-name vol_and_bright \
    -u low \
    --icon xfpm-brightness-lcd \
    --stack-tag brightness_tag \
    -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) ))]]
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
hl.bind(MAIN_MOD .. " + Z", zoom, { description = "Zoom reset" })
hl.bind(MAIN_MOD .. " + mouse_up", function()
	zoom(0.5)
end, { description = "Zoom in (Scroll wheel)" })
hl.bind(MAIN_MOD .. " + code:21", function()
	zoom(0.5)
end, { repeating = true, description = "Zoom in (Keyboard)" })
hl.bind(MAIN_MOD .. " + mouse_down", function()
	zoom(-0.5)
end, { description = "Zoom out (Scrool wheel)" })
hl.bind(MAIN_MOD .. " + code:20", function()
	zoom(-0.5)
end, { repeating = true, description = "Zoom out (Keyboard)" })
hl.gesture({ fingers = 2, mods = MAIN_MOD, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

-- OBS
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("obs-cmd recording toggle"), { description = "OBS toggle recording" })
hl.bind(
	"CTRL + SHIFT + P",
	hl.dsp.exec_cmd("obs-cmd recording toggle-pause"),
	{ description = "OBS toggle pause recording" }
)

-- Keybind Help
hl.bind(
	MAIN_MOD .. " + SHIFT + code:61",
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
	match = { class = MAIL },
	workspace = "3 silent",
})
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})
