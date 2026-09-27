pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool visible: true

    IpcHandler {
        target: "bar"

        function toggle(): void {
            root.visible = !root.visible;
        }
    }
}
