import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

AzListView {
    id: list

    model: XmlListModel {
        id: indexModel
        source: "tidy://www.svtplay.se/program"
        query: "//li[contains(@class, \"playListItem\")]/a"

        XmlRole {
            name: "text"
            query: "string()"
        }
        XmlRole {
            name: "link"
            query: "@href/string()"
        }
    }

    delegate: ListDelegate {
        text: model.text.slim()
        onClicked: {
            ViewBrowser.currentView.state = { currentIndex: list.currentIndex };
            ViewBrowser.loadView( Qt.resolvedUrl("program.qml"),
                                 { url: "tidy://www.svtplay.se" + model.link + "?tab=episodes&sida=999",
                                     programName: model.text.slim() } );
        }
    }
}
