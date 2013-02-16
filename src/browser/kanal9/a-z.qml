import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

AzListView {
    id: list

    model: XmlListModel {
        source: "tidy://www.kanal9play.se/program"
        query: '//a[@class="k5-AToZPanel-program k5-AToZPanel-channel-KANAL9" or @class="k5-AToZPanel-program k5-AToZPanel-channel-KANAL9 k5-AToZPanel-program-topical"]'

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
            ViewBrowser.loadView( Qt.resolvedUrl("season.qml"),
                                 { url: "tidy://www.kanal9play.se" + model.link,
                                     programName: model.text.slim() } );
        }
    }
}
