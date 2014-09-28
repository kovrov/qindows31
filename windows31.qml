import QtQuick 2.2

Rectangle {
    width: 640
    height: 480
    color: "#c0c0c0"

     FontLoader { id: sysFont; source: "vgasys-fixed.fnt" }

     Text { text: "Fixed-size font"; font.family: sysFont.name }

    Window {
        width: 250
        height: 200
        x: 100
        y: 100
    }
}
