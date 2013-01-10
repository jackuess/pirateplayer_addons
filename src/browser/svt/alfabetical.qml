import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: list

    model: XmlListModel {
        id: indexModel
        source: "tidy://www.svtplay.se/program"
        query: "//li[contains(@class, \"playListItem\")]/a"

        onStatusChanged: list.statusChanged(indexModel.status)

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
                url: "tidy://www.svtplay.se" + model.link + "?tab=episodes&sida=999",
                name: model.text.slim(),
                source: Qt.resolvedUrl("program.qml"),
                callback: function () {
                    this.loader.source = this.source;
                    //this.loader.item.model.source = this.url;
                    this.loader.item.programName = this.name;

                    var doc = new XMLHttpRequest();
                    var myLoader = this.loader;
                    doc.onreadystatechange = function() {
                        if (doc.readyState == XMLHttpRequest.DONE)
                            myLoader.item.model.xml = doc.responseText.replace("<![if !(lte IE 7)]>", "").replace("<![endif]>", "");
                    }
                    doc.open("GET", this.url);
                    doc.send();
                }};
            ViewStack.pushFactory(newFactory);
        }
    }
    section.property: "text"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: AzDelegate {}
}
