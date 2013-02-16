import QtQuick 1.1

Item {
    property alias currentIndex: list.currentIndex
    property alias model: list.model
    property alias delegate: list.delegate

    anchors.fill: parent
    Keys.forwardTo: header

    PirateListView {
        id: list

        anchors.top: header.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right

        section.property: "text"
        section.criteria: ViewSection.FirstCharacter
    }

    AlfabetListHeader { id: header; target: list }

    XmlListModelStatusMessage { target: list.model }
}
