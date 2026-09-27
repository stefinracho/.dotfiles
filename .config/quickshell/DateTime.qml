import Quickshell
import Quickshell.Widgets
import QtQuick

WrapperRectangle {
    id: dateTime

    border.color: Theme.border
    border.width: 1
    color: Theme.background
    radius: Theme.radius

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        color: Theme.foreground
        font.pixelSize: Theme.fontSize
        padding: Theme.space(2)
        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")
    }
}
