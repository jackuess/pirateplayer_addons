import QtQuick 1.1

import "../../common.js" as Common

Rectangle {
    id: listItem

    property alias text: label.text
    property alias textColor: label.color
    property alias fontBold: label.font.bold
    property alias fontPointSize: label.font.pointSize
    property alias imgSource: img.source

    signal clicked()
    signal entered()

    height: Math.max(label.height + 20, 70)
    anchors.left: parent.left
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    color: [Qt.rgba(0, 0, 0, 0.05),Qt.rgba(0, 0, 0, 0)][index%2]

    Image {
        id: img

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 50
        y: label.height > img.height ? label.height/2 : 10

        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: parent.width - img.width - img.anchors.rightMargin - anchors.leftMargin
        //color: "#eee";
        //color: "#222"
        wrapMode: Text.WordWrap
    }
//    Rectangle {
//        anchors.bottom: parent.bottom
//        anchors.horizontalCenter: parent.horizontalCenter
//        //color: "#373A3D"
//        color: Qt.rgba(0, 0, 0, 0.2)
//        width: parent.width - 20
//        height: 1
//    }

    MouseArea {
        anchors.fill: parent
        onClicked: listItem.clicked()
    }
}
