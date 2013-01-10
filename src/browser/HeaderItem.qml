import QtQuick 1.1

import "common.js" as Common

Rectangle {
    id: listItem

    property alias text: label.text
    property alias textColor: label.color
    property alias fontBold: label.font.bold
    property alias fontPointSize: label.font.pointSize

    height: 40
    width: parent.width
    color: "transparent"

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        x: 10
        color: "#eee"
        //font.pointSize: 6
        font.bold: true
        wrapMode: Text.WordWrap
    }

    Rectangle {
        anchors.bottom: parent.bottom
        height: 2
        width: parent.width
        color: "#33B5E5"
    }
}
