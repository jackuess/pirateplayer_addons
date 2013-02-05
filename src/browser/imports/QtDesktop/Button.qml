import QtQuick 1.1

Rectangle {
    id: button

    property alias text: label.text

    signal clicked

    border.color: Qt.rgba(0,0,0, .1)
    border.width: 2
    radius: 5

    clip: true

    color: "transparent"

    Rectangle {
        id: horizGradient
        width: parent.height
        height: parent.width
        anchors.centerIn: parent
        rotation: 270

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(0,0,0, .05) }
            GradientStop { position: .5; color: Qt.rgba(255,255,255, 0) }
            GradientStop { position: 1; color: Qt.rgba(0,0,0, .05) }
        }
    }

    Text {
        id: label

        anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }
}
