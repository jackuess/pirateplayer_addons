import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: list

    property int number

    model: XmlListModel {

        onStatusChanged: list.statusChanged(status)

        source: "tidy://www.tv" + number + "play.se/program"
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/1999/xhtml';"
        query: "//div[@id=\"main-content\"]//a[string()]"

        XmlRole {
            name: "text"
            query: "string()"
        }
        XmlRole {
            name: "link"
            query: "@href/string()"
        }
    }
    delegate: ListItem {
        text: model.text.slim()

        onClicked: {
            var newFactory = {
                loader: currentView,
                url: "tidy://www.tv" + number + "play.se" + model.link,
                source: Qt.resolvedUrl("../tv" + number + "/program.qml"),
                callback: function () {
                    this.loader.source = this.source;
                    this.loader.item.model.source = this.url;
                }};
            ViewStack.pushFactory(newFactory);
        }
    }
    section.property: "text"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: AzDelegate {}
}
