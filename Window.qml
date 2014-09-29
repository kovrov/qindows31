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
            root.z = Globals.maxZOrder++
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

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
        }
    }
    Rectangle {
        id: windowBorderBottom
        color: "black"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 4

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
        }
    }
    Rectangle {
        id: windowBorderLeft
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
        }

        // fixup top
        Rectangle {
            color: "#c0c0c0"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 1
            height: 2
            width: 1
        }

        // fixup bottom
        Rectangle {
            color: "#c0c0c0"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            height: 2
            width: 1
        }
    }
    Rectangle {
        id: windowBorderRight
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 4
        height: parent.height

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
        }

        // fixup top
        Rectangle {
            color: "#c0c0c0"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 1
            height: 2
            width: 1
        }

        // fixup bottom
        Rectangle {
            color: "#c0c0c0"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            height: 2
            width: 1
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            root.active = true
        }
    }

    Rectangle {
        id: windowTitleBar
        color: root.active ? "#000080" : "#ffffff"
        anchors.top: windowBorderTop.bottom
        anchors.left: windowBorderLeft.right
        anchors.right: windowBorderRight.left
        height: 18

        Rectangle {
            id: windowTitleButton
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            color: "#c0c0c0"

            Rectangle {
                id: windowTitleButtonNotchShade
                color: "#808080"
                anchors.top: windowTitleButtonNotch.top
                anchors.left: windowTitleButtonNotch.left
                width: windowTitleButtonNotch.width
                height: windowTitleButtonNotch.height
                anchors.topMargin: 1
                anchors.leftMargin: 1
            }

            Rectangle {
                id: windowTitleButtonRightHandBorder
                anchors.top: parent.top
                anchors.topMargin: -windowBorderTop.height
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 1
                color: "#000000"
            }

            Rectangle {
                id: windowTitleButtonNotch
                anchors.centerIn: parent
                width: 13
                height: 3
                color: "#000000"

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "white"
                }
            }
        }

        WindowsText {
            id: windowTitle
            y: 1
            anchors.centerIn: parent
            color: root.active ? "white" : "black"
        }

        Row {
            anchors.right: parent.right
            WindowMaxMinControl {
            }
            WindowMaxMinControl {
                maximizeButton: true
            }
        }

        Rectangle {
            id: titleBarBottom
            x: -windowBorderLeft.width
            anchors.top: parent.bottom
            height: 1
            width: root.width
            color: "black"
        }

        MouseArea {
            anchors.fill: parent
            drag.target: root
            onPressed: {
                root.active = true
            }
        }
    }
}
