local terminal = "kitty"
local menu = "wofi --show drun"
local editor = "emacs"
local mainMod = "SUPER"

local primary = "rgb(ffb4a9)"
local inactive = "rgb(3d3231)"

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpolkitagent")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("blueman-applet")
end)

hl.config({
    input = {
        kb_layout = "br",
        kb_variant = "abnt2",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
        },
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = primary,
            inactive_border = inactive,
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        active_opacity = 0.90,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1.0,
    },
})

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

for i = 1, 4 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("Print", hl.dsp.exec_cmd([[hyprshot -m region -o "$HOME/Pictures/Screenshots"]]))
hl.bind("CTRL + Print", hl.dsp.exec_cmd([[hyprshot -m window -o "$HOME/Pictures/Screenshots"]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[hyprshot -m output -o "$HOME/Pictures/Screenshots"]]))
