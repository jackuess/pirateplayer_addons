import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: list

    Component.onCompleted: statusChanged(XmlListModel.Ready)

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

    delegate: ListItem {
        text: model.title

        onClicked: {
            var newFactory = {
                loader: currentView,
                url: model.url,
                name: model.text,
                source: Qt.resolvedUrl(model.module + ".qml"),
                callback: function () {
                    this.loader.source = this.source;
                    if (model.module === "program")
                        this.loader.item.model.source = this.url;
                }};
            ViewStack.pushFactory(newFactory);
        }
    }
}
