import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: list

    property int number

    model: XmlListModel {

        onStatusChanged: list.statusChanged(status)

        source: "tidy://urplay.se/A-O"
        query: '//*[@id="alphabet"]/ul/li/a'

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
        id: item
        text: model.text.slim().replace(/(TV)|(Radio)$/, "")

        onClicked: {
            var newFactory = {
                loader: currentView,
                url: "tidy://www.urplay.se" + model.link,
                source: Qt.resolvedUrl("program.qml"),
                programName: item.text,
                callback: function () {
                    this.loader.source = this.source;
                    this.loader.item.model.source = this.url;
                    this.loader.item.programName = this.programName;
                }};
            ViewStack.pushFactory(newFactory);
        }
    }
    section.property: "text"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: AzDelegate {}
}
