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
        id: indexModel

        onStatusChanged: list.statusChanged(status)

        source: "tidy://www.kanal5play.se/program"
        query: "//div[@class=\"logo\" and descendant::img]"

        XmlRole {
            name: "text"
            query: "a[@class=\"ajax\"]/img/@alt/string()"
        }
        XmlRole {
            name: "image"
            query: "a[@class=\"ajax\"]/img/@src/string()"
        }
        XmlRole {
            name: "link"
            query: "a[@class=\"ajax\"]/@href/string()"
        }
    }
    delegate: ListItem {
        height: 70
        fontPixelSize: 20
        gradient: Gradient {
            GradientStop { position: 0.0; color: ["#444","#444"][model.index%2] }
            GradientStop { position: 1.0; color: ["#222","#666"][model.index%2] }
        }
        imgSource: model.image
        text: model.text.slim()

        onClicked: {
            var newFactory = {
                loader: currentView,
                url: "tidy://www.kanal5play.se" + model.link,
                source: Qt.resolvedUrl("season.qml"),
                name: model.text.slim(),
                callback: function () {
                    this.loader.source = this.source;
                    this.loader.item.model.source = this.url;
                    this.loader.item.programName = this.name;
                    //this.source = "kanal5/season.qml"
                }};
            ViewStack.pushFactory(newFactory);
        }
    }
    section.property: "text"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: AzDelegate {}
}
