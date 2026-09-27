import QtQuick
import Quickshell.Hyprland
import Quickshell.Widgets

WrapperRectangle {
    property int maxTitleWidth: 300

    border.color: Theme.border
    border.width: 1
    color: Theme.background
    radius: Theme.radius
    width: Math.min(implicitWidth, maxTitleWidth)

    Text {
        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""

        color: Theme.foreground
        elide: Text.ElideRight
        font.pixelSize: Theme.fontSize
        padding: Theme.space(2)
    }
}
