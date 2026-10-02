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
        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")
        color: Theme.foreground
        font.pixelSize: Theme.fontSize
        padding: Theme.space(2)
    }
}
