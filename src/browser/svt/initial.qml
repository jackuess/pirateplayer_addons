import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

ListView {
    id: list
    spacing: 0
    height: 1
    onContentHeightChanged: if (contentHeight > 0) height = contentHeight

    signal statusChanged(int newStatus)

    model: XmlListModel {
        id: indexModel
        source: "tidy://www.svtplay.se/program"
        query: "//a[@class=\"playAlphabeticLetterLink\"]"

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
        height: 30
        gradient: Gradient {
            GradientStop { position: 0.0; color: ["#444","#444"][model.index%2] }
            GradientStop { position: 1.0; color: ["#222","#666"][model.index%2] }
        }
        text: model.text.slim()

        onClicked: {
            var newFactory = {
                loader: currentView,
                url: "tidy://www.svtplay.se" + model.link,
                name: model.text.slim(),
                source: "program.qml",
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
