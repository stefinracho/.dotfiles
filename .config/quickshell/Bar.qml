import QtQuick

Item {
    id: root

    required property var screen

    anchors.fill: parent
    implicitHeight: Math.max(workspaces.implicitHeight, title.implicitHeight, rightSide.implicitHeight)

    // Left (Workspaces)
    Workspaces {
        id: workspaces
        screen: root.screen
        anchors.left: parent.left
    }

    // Center (Window Title)
    WindowTitle {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Right (Volume, System Tray, Datetime)
    Row {
        id: rightSide

        anchors.right: parent.right
        spacing: Theme.space(2)

        TimeTracker {}
        SystemTray {}
        DateTime {}
    }
}
