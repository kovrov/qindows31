import QtQuick 2.2

Rectangle {
    width: 640
    height: 480
    color: "#c0c0c0"

    Repeater {
        anchors.fill: parent

        delegate: Window {
            width: model.width
            height: model.height
            title: model.title
            resizable: model.resizable

            WindowsText {
                text: model.text
            }

            Component.onCompleted: {
                x = Math.floor(Math.random() * (parent.width - width));
                y = Math.floor(Math.random() * (parent.height - height));
            }

            onFocusChanged: {
                if (focus)
                    windowModel.move(index, windowModel.count - 1, 1);
            }
        }

        model: ListModel {
            id: windowModel

            ListElement {
                width: 320
                height: 200
                title: "Another window"
                text: "Some more text"
                resizable: true
            }
            ListElement {
                width: 256
                height: 220
                title: "A window"
                text: "Hello, world"
                resizable: true
            }
            ListElement {
                width: 200
                height: 200
                title: "A dialog box"
                text: "A nonresizable window"
            }
        }
    }
}
