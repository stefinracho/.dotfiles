pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool active: false

    function refresh(): void {
        check.exec(["bash", "-lc", "command -v timew >/dev/null && [ \"$(timew get dom.active.tags.count 2>/dev/null || echo 0)\" -gt 0 ]"]);
    }

    Process {
        id: check

        onExited: function (exitCode) {
            root.active = exitCode === 0;
        }
    }

    IpcHandler {
        target: "timetracker"

        function refresh(): void {
            root.refresh();
        }
    }

    Component.onCompleted: refresh()
}
