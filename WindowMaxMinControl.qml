import QtQuick 2.0

Rectangle {
    width: 18
    height: 18
    color: "#c0c0c0"
    property bool maximizeButton: false

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

    Triangle {
        p1: !maximizeButton ? Qt.vector2d(width / 2 - 3.5, height / 2 - 2) : Qt.vector2d(width / 2 - 3.5, height / 2 + 2)
        p2: !maximizeButton ? Qt.vector2d(width / 2, height / 2 + 1) : Qt.vector2d(width / 2, height / 2 - 1);
        p3: !maximizeButton ? Qt.vector2d(width / 2 + 3.5, height / 2 - 2) : Qt.vector2d(width / 2 + 3.5, height / 2 + 2)
        width: parent.width
        height: parent.height
        color: "black"
    }
}

