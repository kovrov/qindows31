import QtQuick 2.2
import "globals.js" as Globals

// window border
Rectangle {
    id: root
    color: "white"
    default property alias content: content.children
    property alias title: windowTitle.text
    property bool active: false;
    property bool resizable: true

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

    MouseArea {
        anchors.fill: parent
        onPressed: {
            root.active = true
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
        height: root.resizable ? 4 : 1

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
            visible: root.resizable
        }

        MouseArea {
            enabled: root.resizable
            // XXX: is it a bug that enabled doesn't affect cursorShape? hmm.
            cursorShape: root.resizable ? Qt.SizeVerCursor : Qt.ArrowCursor
            anchors.fill: parent
            property real lastPos
            onPressed: {
                lastPos = mouse.y
            }
            onPositionChanged: {
                root.y = Math.round(root.y - (lastPos - mouse.y))
                root.height = Math.round(root.height + (lastPos - mouse.y))
            }
        }

    }
    Rectangle {
        id: windowBorderBottom
        color: "black"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.resizable ? 4 : 1

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
            visible: root.resizable
        }

        MouseArea {
            enabled: root.resizable
            cursorShape: root.resizable ? Qt.SizeVerCursor : Qt.ArrowCursor
            anchors.fill: parent
            property real lastPos
            onPressed: {
                lastPos = mouse.y
            }
            onPositionChanged: {
                root.height = Math.round(root.height + (mouse.y - lastPos))
            }
        }
    }
    Rectangle {
        id: windowBorderLeft
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.resizable ? 4 : 1

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
            visible: root.resizable
        }

        MouseArea {
            enabled: root.resizable
            cursorShape: root.resizable ? Qt.SizeHorCursor : Qt.ArrowCursor
            anchors.fill: parent
            property real lastPos
            onPressed: {
                lastPos = mouse.x
            }
            onPositionChanged: {
                root.x = Math.round(root.x - (lastPos - mouse.x))
                root.width = Math.round(root.width + (lastPos - mouse.x))
            }
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
            visible: root.resizable
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
            visible: root.resizable
        }
    }
    Rectangle {
        id: windowBorderRight
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: root.resizable ? 4 : 1

        Rectangle {
            color: "#c0c0c0"
            anchors.fill: parent
            anchors.margins: 1
            visible: root.resizable
        }

        MouseArea {
            enabled: root.resizable
            cursorShape: root.resizable ? Qt.SizeHorCursor : Qt.ArrowCursor
            anchors.fill: parent
            property real lastPos
            onPressed: {
                lastPos = mouse.x
            }
            onPositionChanged: {
                root.width = Math.round(root.width + (mouse.x - lastPos))
            }
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
            visible: root.resizable
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
            visible: root.resizable
        }
    }

    Rectangle {
        id: windowTitleBar
        color: root.active ? "#000080" : "#ffffff"
        anchors.top: windowBorderTop.bottom
        anchors.left: windowBorderLeft.right
        anchors.right: windowBorderRight.left
        height: 18

        MouseArea {
            anchors.fill: parent
            drag.target: root
            onPressed: {
                root.active = true
            }
        }

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
            visible: root.resizable
            anchors.right: parent.right
            WindowMaxMinControl {
                height: windowTitleBar.height
            }
            WindowMaxMinControl {
                maximizeButton: true
                height: windowTitleBar.height

                Rectangle {
                    color: "black"
                    width: 1
                    height: windowBorderTop.height
                    y: -windowBorderTop.height
                }

                onClicked: {
                    root.width = root.parent.width
                    root.height = root.parent.height
                    root.x = 0
                    root.y = 0
                }
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
    }
}
