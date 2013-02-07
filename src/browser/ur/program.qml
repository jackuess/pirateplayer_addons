import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: list

    property int programSeason
    property string programName

    model: XmlListModel {
        id: indexModel

        onStatusChanged: list.statusChanged(status)

        query: "//section[@class=\"tv\" or @class=\"radio\"]/a"

        XmlRole {
            name: "title"
            query: "hgroup/h1/string()"
        }
        XmlRole {
            name: "description"
            query: "div[@class=\"details\"]/string()"
        }

        XmlRole {
            name: "thumb"
            query: "span/img/@src/string()"
        }
        XmlRole {
            name: "link"
            query: "@href/string()"
        }
    }
    delegate: ListItem {
        imgSource: model.thumb
        text: "<strong>" + model.title.slim() + "</strong><br/><small>" + model.description + "</small>"

        onClicked: {
            ViewStack.piratePlay( "http://urplay.se" + model.link,
                                  { title: model.title.slim(),
                                    name: list.programName,
                                    description: model.description.slim() } );
        }
    }
}
