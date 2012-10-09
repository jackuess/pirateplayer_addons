import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common

import ".."

ListView {
    id: list

    signal statusChanged(int newStatus)

    height: 1
    onContentHeightChanged: if (contentHeight > 0) height = contentHeight
    model: XmlListModel {
        onStatusChanged: list.statusChanged(status)

        source: "tidy://www.tv4play.se/alla_program"
        query: "//ul/li[h3[@class=\"video-title\"]]"

        XmlRole {
            name: "text"
            query: "h3/a/string()"
        }
        XmlRole {
            name: "link"
            query: "h3/a/@href/string()"
        }
        XmlRole {
            name: "description"
            query: "div/p[@class=\"video-description\"]/string()"
        }
    }
    delegate: ListItem {
        height: 30
        gradient: Gradient {
            GradientStop { position: 0.0; color: ["#444","#444"][model.index%2] }
            GradientStop { position: 1.0; color: ["#222","#666"][model.index%2] }
        }
        text: model.text.slim()

        onClicked: {
            var newFactory = {
                loader: currentView,
                url: "tidy://www.tv4play.se" + model.link,
                source: "program.qml",
                name: model.text.slim(),
                callback: function () {
                    this.loader.source = this.source;
                    this.loader.item.url = this.url;
                    this.loader.item.programName = this.name;
                }};
            ViewStack.pushFactory(newFactory);
        }
    }
    section.property: "text"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: AzDelegate {}
}
