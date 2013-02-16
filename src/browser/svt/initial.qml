import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    id: list

    model: ListModel {
        ListElement {
            title: "Program A-Ö"
            module: "alfabetical"
            url: ""
        }
        ListElement {
            title: "Rekommenderat"
            module: "program"
            url: "tidy://www.svtplay.se/?tab=recommended&sida=3"
        }
        ListElement {
            title: "Senaste program"
            module: "program"
            url: "tidy://www.svtplay.se/?tab=episodes&sida=3"
        }
        ListElement {
            title: "Kanaler (live)"
            module: "live"
            url: ""
        }
    }

    delegate: ListDelegate {
        text: model.title

        onClicked: {
            ViewBrowser.currentView.state = { currentIndex: list.currentIndex };
            ViewBrowser.loadView( Qt.resolvedUrl(model.module + ".qml"), model.module === "program" ? { url: model.url } : {} );
        }
    }
}
