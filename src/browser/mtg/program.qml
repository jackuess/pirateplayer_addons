import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    model: XmlListModel {
        id: programModel
        source: ViewBrowser.currentView.args.url
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

    delegate: ListDelegate {
        text: model.title.slim() + " avsnitt <strong>" + model.epNo + "</strong><br/>" + model.time

        onClicked: {
            ViewBrowser.piratePlay( "http://www.tv" + ViewBrowser.currentView.args.n + "play.se" + model.link,
                                  { title: model.epNo,
                                    name: model.title.slim(),
                                    time: model.time} );
        }
    }

    XmlListModelStatusMessage { target: programModel }
}
