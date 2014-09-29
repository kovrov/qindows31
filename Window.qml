import QtQuick 2.2
import "globals.js" as Globals

// window border
Rectangle {
    id: root
    color: "white"
    default property alias content: content.children
    property alias title: windowTitle.text
    property bool active: false;

    Component.onCompleted: {
        x = Math.floor(Math.random() * (parent.width - width));
        y = Math.floor(Math.random() * (parent.height - height));

        this.active = true;
    }

    onActiveChanged: {
        if (active) {
            if (Globals.currentlySelectedWindow)
                Globals.currentlySelectedWindow.active = false;

            Globals.currentlySelectedWindow = this;
        }
    }

    Item {
        id: content
        anchors.top: windowTitleBar.bottom
        anchors.bottom: windowBorderBottom.top
        anchors.left: windowBorderLeft.right
        anchors.right: windowBorderRight.left
    }

    Rectangle {
        id: windowBorderTop
        color: "black"
        anchors.left: parent.left
        anchors.right: parent.right
        height: 4
    }
    Rectangle {
        id: windowBorderBottom
        color: "black"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 4
    }
    Rectangle {
        id: windowBorderLeft
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4
    }
    Rectangle {
        id: windowBorderRight
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 4
        height: parent.height
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            root.active = true
            root.z = Globals.maxZOrder++
        }
    }

    Rectangle {
        id: windowTitleBar
        color: root.active ? "#000080" : "#ffffff"
        anchors.top: windowBorderTop.bottom
        anchors.left: windowBorderLeft.right
        anchors.right: windowBorderRight.left
        height: 20

        WindowsText {
            id: windowTitle
            y: 1
            anchors.centerIn: parent
            color: root.active ? "white" : "black"
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
                root.active = true
                root.z = Globals.maxZOrder++
            }
        }
    }
}
