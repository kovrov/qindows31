import QtQuick 2.0

MouseArea {
    id: root
    width: height
    property bool maximizeButton: false
    Rectangle {
        anchors.fill: parent
        color: "#c0c0c0"

        Rectangle {
            id: divider
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: "black"
        }

        Rectangle {
            id: rightGrey
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 2
            color: "#808080"
        }

        Rectangle {
            id: bottomGrey
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.right: parent.right
            height: 2
            color: "#808080"
        }

        Rectangle {
            id: leftWhite
            anchors.left: divider.left
            anchors.leftMargin: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            width: 1
            color: "white"
        }

        Rectangle {
            id: topWhite
            anchors.left: leftWhite.left
            anchors.right: parent.right
            anchors.rightMargin: 1
            height: 1
            color: "white"
        }

        Column {
            id: col
            y: ((root.height - col.height) / 2) + (maximizeButton ? -0.4 : 0.4)
            x: (root.width - col.width) / 2
            width: 7
            Repeater {
                model: 4

                Rectangle {
                    color: "black"
                    height: 1
                    width: maximizeButton ? 1 + index * 2 : 7 - index * 2
                    x: (parent.width - width) / 2
                }
            }
        }
    }
}

