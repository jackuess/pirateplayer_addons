import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common

import ".."

ListView {
    id: list

    property int number

    signal statusChanged(int newStatus)

    height: 1
    onContentHeightChanged: if (contentHeight > 0) height = contentHeight

    model: XmlListModel {
        onStatusChanged: list.statusChanged(status)

        query: "//table[@class=\"clearfix clip-list video-tree\"]//tr[descendant::th[a]]"
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/1999/xhtml';"

        XmlRole {
            name: "title"
            query: "th[@class=\"col1\"]/a/string()"
        }
        XmlRole {
            name: "epNo"
            query: "td[@class=\"col2\"]/string()"
        }
        XmlRole {
            name: "time"
            query: "td[@class=\"col4\"]/string()"
        }
        XmlRole {
            name: "link"
            query: "th[@class=\"col1\"]/a/@href/string()"
        }
    }
    delegate: ListItem {
        height: 40
        fontPixelSize: 15
        text: model.title.slim() + " avsnitt <strong>" + model.epNo + "</strong><br/>" + model.time
        gradient: Gradient {
            GradientStop { position: 0.0; color: ["#555","#333"][model.index%2] }
            GradientStop { position: 1.0; color: ["#111","#777"][model.index%2] }
        }

        onClicked: {
            mainWindow.getStreams( "http://www.tv" + number + "play.se" + model.link,
                                  { title: model.epNo,
                                    name: model.title.slim(),
                                    time: model.time} );
        }
    }
}
