import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

Row {
    id: root

    required property var screen

    spacing: Theme.space(2)

    Repeater {
        model: Hyprland.workspaces

        delegate: WrapperRectangle {
            required property var modelData

            visible: modelData.monitor && root.screen && modelData.monitor.name === root.screen.name

            color: modelData.active ? Theme.background : "transparent"
            border.color: mouseArea.containsMouse ? Theme.ring : modelData.active ? Theme.border : "transparent"
            border.width: 1
            radius: Theme.radius

            Text {
                text: modelData.id

                color: Theme.foreground
                font.pixelSize: Theme.fontSize
                padding: Theme.space(2)

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: modelData.activate()
                }
            }
        }
    }
}
