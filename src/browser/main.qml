import QtQuick 1.1
import QtDesktop 0.1

import "viewstack.js" as ViewStack

Rectangle {
    id: root
    
    property string title: "Bläddra"

    width: 480; height: 640
    color: "transparent"

    signal episode(string url, string title, string name, string time, int season, string description)

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

    ScrollArea {
        id: scrollArea
        anchors.left: backButton.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        frame: false
        verticalScrollBar.visible: true

        Component.onCompleted: ViewStack.setScrollArea(scrollArea)

        Loader {
            id: currentView

            property int status: XmlListModel.Null

            width: scrollArea.childrenRect.width - scrollArea.verticalScrollBar.width-10
            sourceComponent: menuView

            onSourceChanged: {
                if (ViewStack.factoryStack.length > 0)
                    state = "StackNotEmpty";
                else
                    state = "StackEmpty";
            }
            onLoaded: if (currentView.sourceComponent !== menuView) progress.state = "Loading"


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
                if (newStatus == XmlListModel.Loading)
                    progress.state = "Loading";
                else {
                    if (typeof ViewStack.currentFactory.scroll !== "undefined")
                        scrollArea.verticalScrollBar.value = ViewStack.currentFactory.scroll;
                    progress.state = "Ready";
                }
            }
        }
    }

    Text {
        id: progress
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 30
        text: "Laddar..."
        state: "Ready"
        states: [
            State {
                name: "Loading"
                PropertyChanges { target: progress; visible: true }
            },
            State {
                name: "Ready"
                PropertyChanges { target: progress; visible: false }
            }]
    }

    Component {
        id: menuView

        ListView {
            id: list
            height: 1

            signal statusChanged(int newStatus)

            onContentHeightChanged: {
                progress.state = "Ready"
                if (contentHeight > 0) {
                    list.statusChanged(XmlListModel.Ready)
                    height = contentHeight
                }
            }

            model: ListModel {
                ListElement {
                    title: "SVT-play"
                    logo: "http://www.svtplay.se/public/2012.54/images/svt-play-2x.png"
                    module: "svt"
                }
                ListElement {
                    title: "TV3-play"
                    logo: "http://images2.wikia.nocookie.net/__cb20091126144517/logopedia/images/c/c6/TV3_logo_1990.png"
                    module: "tv3"
                }
                ListElement {
                    title: "TV4-play"
                    module: "tv4"
                    logo: "http://images1.wikia.nocookie.net/__cb20100305140436/logopedia/images/3/31/TV4_Play.svg"
                }
                ListElement {
                    title: "Kanal5-play"
                    logo: "http://images2.wikia.nocookie.net/__cb20091126112949/logopedia/images/1/14/Kanal_5.svg"
                    module: "kanal5"
                }

                ListElement {
                    title: "TV6-play"
                    logo: "http://www.tv6play.se/themes/play/images/tv6-logo.png"
                    module: "tv6"
                }
                ListElement {
                    title: "TV8-play"
                    logo: "http://www.viasat.se/sites-paytv/viasat.se/files/kanal8_play_0.png"
                    module: "tv8"
                }
            }
            delegate: ListItem {
                height: 70

                fontBold: true
                gradient: Gradient {
                    GradientStop { position: 0.0; color: ["#555","#777"][model.index%2] }
                    GradientStop { position: 1.0; color: ["#111","#333"][model.index%2] }
                }
                imgSource: model.logo
                text: model.title

                onClicked: {
                    ViewStack.currentFactory = {
                        view: menuView,
                        loader: currentView,
                        callback: function (loader) {
                            this.loader.sourceComponent = this.view;
                        }};
                    var newFactory = {
                        source: Qt.resolvedUrl(model.module + "/initial.qml"),
                        loader: currentView,
                        callback: function () {
                            this.loader.source = this.source;
                        }
                    };
                    ViewStack.pushFactory(newFactory);
                }
            }
        }
    }
}
