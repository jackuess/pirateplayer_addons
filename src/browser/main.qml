import QtQuick 1.1
import QtDesktop 0.1

import "viewbrowser.js" as ViewBrowser

Item {
    Component.onCompleted: {
        ViewBrowser.setMainWindow(mainWindow);
        ViewBrowser.setLoader(loader);
        ViewBrowser.loadView( Qt.resolvedUrl("menu.qml"), {});
    }

    Button {
        id: backButton
        height: parent.height;
        text: "Bakåt"
        onClicked: ViewBrowser.goBack()
    }

    Loader {
        id: loader
        focus: true
        anchors { left: backButton.right; right: parent.right }
        height: parent.height

        onLoaded: focus = true

        Keys.onPressed: if (event.key == Qt.Key_Backspace && state == "StackNotEmpty") backButton.clicked()

        onSourceChanged: state = ViewBrowser.viewStack.length > 0 ? "StackNotEmpty" : "StackEmpty"
        states: [
            State {
                name: "StackNotEmpty"
                when: ViewBrowser.viewStack.length > 0
                PropertyChanges { target: backButton; width: 50 }
            },
            State {
                name: "StackEmpty"
                when: ViewBrowser.viewStack.length == 0
                PropertyChanges { target: backButton; width: 0 }
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
}
