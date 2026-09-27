import Quickshell
import QtQuick

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            color: "transparent"
            exclusionMode: BarState.visible ? ExclusionMode.Auto : ExclusionMode.Ignore
            implicitHeight: BarState.visible ? bar.implicitHeight : 0
            margins {
                top: Theme.space(2)
                left: Theme.space(2)
                right: Theme.space(2)
            }
            visible: BarState.visible

            anchors {
                top: true
                left: true
                right: true
            }

            Bar {
                id: bar
                screen: modelData
            }
        }
    }
}
