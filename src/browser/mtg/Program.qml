import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common

import ".."

CustomListView {
    id: list

    property int number

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
        text: model.title.slim() + " avsnitt <strong>" + model.epNo + "</strong><br/>" + model.time

        onClicked: {
            ViewStack.piratePlay( "http://www.tv" + number + "play.se" + model.link,
                                  { title: model.epNo,
                                    name: model.title.slim(),
                                    time: model.time} );
        }
    }
}
