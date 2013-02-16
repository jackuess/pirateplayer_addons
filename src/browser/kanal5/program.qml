import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    id: list

    model: XmlListModel {
        id: indexModel

        source: ViewBrowser.currentView.args.url
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
    delegate: ListDelegate {
        imgSource: model.thumb
        text: "<strong>" + model.title.slim() + "</strong><br/><small>" + model.description + "</small>"

        onClicked: {
            ViewBrowser.piratePlay( "http://kanal5play.se" + model.link,
                                  { title: model.title.slim(),
                                    name: ViewBrowser.currentView.args.programName,
                                    season: ViewBrowser.currentView.args.season,
                                    description: model.description.slim() } );
        }
    }

    XmlListModelStatusMessage { target: indexModel }
}
