pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // ─────────────────────────────────────────────
    // Colors
    // ─────────────────────────────────────────────
    readonly property color background: "#80000000"
    readonly property color foreground: "#FFFFFFFF"

    readonly property color border: "#807F7F7F"
    readonly property color ring: "#FFFFFFFF"

    // ─────────────────────────────────────────────
    // Scale
    // ─────────────────────────────────────────────
    readonly property real baseSize: 16

    readonly property real spacingUnit: baseSize * 0.25
    function space(multiplier: real): real {
        return spacingUnit * multiplier;
    }

    readonly property real radius: baseSize * 0.5
    readonly property real iconSize: baseSize * 1.25
    readonly property real fontSize: baseSize * 0.875
}
