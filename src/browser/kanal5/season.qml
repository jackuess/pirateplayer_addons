import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    id: list

    anchors.fill: parent

    model: XmlListModel {
        id: indexModel

        source: ViewBrowser.currentView.args.url
        query: "//div[@class=\"season\"]"

        XmlRole {
            name: "text"
            query: "h2/string()"
        }
        XmlRole {
            name: "link"
            query: "div[@class=\"season-info\"]/a/@href/string()"
        }
    }
    delegate: ListDelegate {
        text: model.text.slim()

        onClicked: {
            ViewBrowser.currentView.state = { currentIndex: list.currentIndex };
            ViewBrowser.loadView( Qt.resolvedUrl("program.qml"),
                                 { url: "tidy://www.kanal5play.se" + model.link,
                                     season: parseInt(model.text.slim().replace("Säsong ", "")),
                                     programName: ViewBrowser.currentView.args.programName } );
        }
    }

    XmlListModelStatusMessage { target: indexModel }
}
