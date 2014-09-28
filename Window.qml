import QtQuick 2.2

// window border
Rectangle {
    color: "white"

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
    }
}
