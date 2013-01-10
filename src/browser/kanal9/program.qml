import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: list

    model: XmlListModel {
        id: indexModel

        onStatusChanged: list.statusChanged(status)

        query: '//div[@class="k5-video-teasers-grid"]//table[not(@width)]//td//a'

        XmlRole {
            name: "title"
            query: "@title/string()"
        }
        XmlRole {
            name: "link"
            query: "@href/string()"
        }
        XmlRole {
            name: "programName"
            query: 'span[@class="title"]/span[@class="program-name"]/string()'
        }

        XmlRole {
            name: "thumb"
            query: "img/@src/string()"
        }
    }
    delegate: ListItem {
        imgSource: model.thumb
        text: model.title.slim()

        onClicked: {
            ViewStack.piratePlay("http://kanal9play.se" + model.link);
        }
    }
}
