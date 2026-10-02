import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets

WrapperRectangle {
    readonly property UPowerDevice battery: UPower.displayDevice

    visible: battery.ready && battery.isPresent

    border.color: Theme.border
    border.width: 1
    color: Theme.background
    radius: Theme.radius

    Row {
        padding: Theme.space(2)
        spacing: Theme.space(1)

        IconImage {
            source: Quickshell.iconPath(battery.iconName)
            anchors.verticalCenter: parent.verticalCenter
            implicitSize: Theme.iconSize * 0.75
        }

        Text {
            text: `${battery.percentage * 100}%`
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
        }
    }
}
