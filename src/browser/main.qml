import QtQuick 1.1
import QtDesktop 0.1

import "viewstack.js" as ViewStack

Rectangle {
    id: root
    
    property string title: "Bläddra"

    width: 480; height: 640
    color: "transparent"

    signal episode(string url, string title, string name, string time, int season, string description)

    Component.onCompleted: ViewStack.setMainWindow(mainWindow)

    Button {
        id: backButton

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        text: "Bakåt"

        onClicked: {
            ViewStack.currentFactory = ViewStack.factoryStack.pop();
            ViewStack.currentFactory.callback();
        }
    }

    Rectangle {
        anchors.left: backButton.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        color: "transparent"

        ScrollArea {
            id: scrollArea
            anchors.fill: parent
            verticalScrollBar.visible: true

            Component.onCompleted: ViewStack.setScrollArea(scrollArea)

            Loader {
                id: currentView

                property int status: XmlListModel.Null

                width: {
                    if (scrollArea.notNative)
                        parent.width
                    else
                        scrollArea.childrenRect.width - scrollArea.verticalScrollBar.width-10
                }
                height: if (scrollArea.notNative) parent.height
                source: "menu.qml"

                onSourceChanged: {
                    if (ViewStack.factoryStack.length > 0)
                        state = "StackNotEmpty";
                    else
                        state = "StackEmpty";
                }
                onLoaded: if (currentView.source != Qt.resolvedUrl("menu.qml") && currentView.source != Qt.resolvedUrl("svt/initial.qml")) progress.state = "Loading"


                state: "StackEmpty"
                states: [
                    State {
                        name: "StackNotEmpty"
                        PropertyChanges {target: backButton; width: 50}
                    },
                    State {
                        name: "StackEmpty"
                        PropertyChanges {target: backButton; width: 0}
                    }

                ]
                transitions: [
                    Transition {
                        from: "StackNotEmpty"
                        to: "StackEmpty"
                        NumberAnimation { target: backButton; properties: "width"; duration: 200}
                    },
                    Transition {
                        from: "StackEmpty"
                        to: "StackNotEmpty"
                        NumberAnimation { target: backButton; properties: "width"; duration: 200}
                    }
                ]
            }
            Connections {
                target: currentView.item
                onStatusChanged: {
                    if (newStatus == XmlListModel.Loading) {
                        progress.state = "Loading";
                    } else if (newStatus == XmlListModel.Error) {
                        console.log("Fel!");
                    } else {
                        if (typeof ViewStack.currentFactory.scroll !== "undefined")
                            scrollArea.verticalScrollBar.value = ViewStack.currentFactory.scroll;
                        if (currentView.item.model.count > 0)
                            progress.state = "Ready";
                        else
                            progress.state = "NothingFound";
                    }
                }
            }
        }
    }

    Text {
        id: progress
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
        state: "Ready"
        states: [
            State {
                name: "Loading"
                PropertyChanges { target: progress; visible: true ; text: "Laddar..."}
            },
            State {
                name: "Ready"
                PropertyChanges { target: progress; visible: false }
            },
            State {
                name: "NothingFound"
                PropertyChanges { target: progress; visible: true ; text: "Ingenting funnet"}
            }]
    }
}
