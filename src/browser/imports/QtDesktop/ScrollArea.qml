import QtQuick 1.1

Rectangle {
    color: "transparent"
    property alias verticalScrollBar: vScrollBar

    property bool notNative: true

    //onHeightChanged: console.log(height)//parent.height = height

    Item {
        //property bool visible
        visible: false
        id: vScrollBar
    }

    MouseArea {
        anchors.fill: parent
        onClicked: console.log(childrenRect)
    }
}
