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

        query: "//div[@class=\"sbs-video-season-episode-teaser\"]"

        XmlRole {
            name: "title"
            query: "table//h4[@class=\"title\"]/a/string()"
        }
        XmlRole {
            name: "description"
            query: "table//p[@class=\"description\"]/string()"
        }

        XmlRole {
            name: "thumb"
            query: "table//img/@src/string()"
        }
        XmlRole {
            name: "link"
            query: "table//h4[@class=\"title\"]/a/@href/string()"
        }
    }
    delegate: ListItem {
        imgSource: model.thumb
        text: "<strong>" + model.title.slim() + "</strong><br/><small>" + model.description + "</small>"

        onClicked: {
            ViewStack.piratePlay( "http://kanal5play.se" + model.link,
                                  { title: model.title.slim(),
                                    name: list.programName,
                                    season: list.programSeason,
                                    description: model.description.slim() } );
        }
    }
}
