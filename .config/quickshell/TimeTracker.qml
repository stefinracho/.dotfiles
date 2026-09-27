import QtQuick
import Quickshell.Widgets

WrapperRectangle {
    visible: TimeTrackerService.active

    border.color: Theme.border
    border.width: 1
    color: Theme.background
    radius: Theme.radius

    Text {
        text: "󰥔"

        color: Theme.foreground
        font.pixelSize: Theme.fontSize
        padding: Theme.space(2)
    }
}
