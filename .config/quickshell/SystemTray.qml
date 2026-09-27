import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

WrapperRectangle {
    id: tray

    color: Theme.background
    border.color: Theme.border
    border.width: 1
    radius: Theme.radius

    Row {
        padding: Theme.space(2)
        spacing: Theme.space(2)

        Repeater {
            model: SystemTray.items

            delegate: IconImage {
                required property SystemTrayItem modelData
                source: modelData.icon
                implicitWidth: Theme.iconSize
                implicitHeight: Theme.iconSize
            }
        }
    }
}
