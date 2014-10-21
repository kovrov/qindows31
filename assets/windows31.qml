import QtQuick 2.2

Rectangle {
    width: 640
    height: 480
    color: "#c0c0c0"

    Window {
        width: 250
        height: 200
        title: "Another window"

        content: WindowsText {
            text: "Some more text"
        }
    }
    Window {
        width: 250
        height: 200
        title: "A window"

        content: WindowsText {
            text: "Hello, world"
        }
    }

    Window {
        width: 200
        height: 200
        title: "A dialog box"
        resizable: false

        content: WindowsText {
            text: "A nonresizable window"
        }
    }
}
