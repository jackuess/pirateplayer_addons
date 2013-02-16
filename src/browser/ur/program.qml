import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    model: XmlListModel {
        id: indexModel

        source: ViewBrowser.currentView.args.url
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

    delegate: ListDelegate {
        imgSource: model.thumb
        text: "<strong>" + model.title.slim() + "</strong><br/><small>" + model.description + "</small>"

        onClicked: {
            ViewBrowser.piratePlay( "http://urplay.se" + model.link,
                                  { title: model.title.slim(),
                                    name: ViewBrowser.currentView.args.programName,
                                    description: model.description.slim() } );
        }
    }

    XmlListModelStatusMessage { target: indexModel }
}
