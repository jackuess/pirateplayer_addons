import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

ListView {
    id: list

    signal statusChanged(int newStatus)

    property int programSeason
    property string programName

    height: 1
    onContentHeightChanged: if (contentHeight > 0) height = contentHeight
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
        height: 70
        fontPixelSize: 15
        gradient: Gradient {
            GradientStop { position: 0.0; color: ["#444","#444"][model.index%2] }
            GradientStop { position: 1.0; color: ["#222","#666"][model.index%2] }
        }
        imgSource: model.thumb
        text: "<strong>" + model.title.slim() + "</strong><br/><small>" + model.description + "</small>"

        onClicked: {
            mainWindow.getStreams( "http://kanal5play.se" + model.link,
                                  { title: model.title.slim(),
                                    name: list.programName,
                                    season: list.programSeason,
                                    description: model.description.slim() } );
        }
    }
}
