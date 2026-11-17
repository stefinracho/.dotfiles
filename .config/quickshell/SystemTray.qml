import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

WrapperRectangle {
    color: Theme.background
    border.color: Theme.border
    border.width: 1
    radius: Theme.radius

    Row {
        padding: Theme.space(2)
        spacing: Theme.space(2)

        Repeater {
            model: SystemTray.items

            delegate: MouseArea {
                id: trayItem

                required property SystemTrayItem modelData

                implicitWidth: Theme.iconSize
                implicitHeight: Theme.iconSize
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: event => {
                    if (event.button === Qt.LeftButton)
                        trayItem.modelData.activate();
                    else if (event.button === Qt.RightButton)
                        menuAnchor.open();
                }

                IconImage {
                    anchors.fill: parent
                    source: parent.modelData.icon
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: trayItem.modelData.menu
                    anchor.item: trayItem
                }
            }
        }
    }
}
