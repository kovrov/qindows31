import QtQuick 2.2
import "globals.js" as Globals

// window border
Rectangle {
    id: root
    color: "white"
    default property alias content: content.children
    property alias title: windowTitle.text

    Component.onCompleted: {
        x = Math.floor(Math.random() * (parent.width - width));
        y = Math.floor(Math.random() * (parent.height - height));
    }

    Item {
        id: content
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // windowBorderTop is part of the title bar, below
    Rectangle {
        id: windowBorderBottom
        color: "black"
        x: 0
        y: parent.height
        width: parent.width
        height: 1
    }
    Rectangle {
        id: windowBorderLeft
        color: "black"
        x: 0
        y: 0
        width: 1
        height: parent.height
    }
    Rectangle {
        id: windowBorderRight
        color: "black"
        x: parent.width
        y: 0
        width: 1
        height: parent.height
    }

    Rectangle {
        id: windowTitleBar
        color: "#000080"
        x: 1
        height: 20
        width: parent.width

        WindowsText {
            id: windowTitle
            y: 1
            anchors.centerIn: parent
            color: "white"
        }

        Rectangle {
            id: windowBorderTop
            color: "black"
            x: 0
            y: 0
            width: parent.width
            height: 1
        }

        Rectangle {
            id: titleBarBottom
            y: 20
            height: 1
            width: parent.width
            color: "black"
        }

        MouseArea {
            anchors.fill: parent
            drag.target: root
            onPressed: {
                root.z = Globals.maxZOrder++
                console.log("z is now " + root.z + " max " + Globals.maxZOrder)
            }
        }
    }
}
