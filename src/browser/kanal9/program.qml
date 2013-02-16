import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    model: XmlListModel {
        id: programModel

        namespaceDeclarations: ViewBrowser.currentView.args.needsNSDecl ? "declare default element namespace 'http://www.w3.org/1999/xhtml';" : ""
        source: ViewBrowser.currentView.args.url
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
            name: "thumb"
            query: "img/@src/string()"
        }
    }
    delegate: ListDelegate {
        imgSource: model.thumb
        text: model.title.slim()

        onClicked: {
            ViewBrowser.piratePlay( "http://kanal9play.se" + model.link,
                                 { title: model.title,
                                     name: ViewBrowser.currentView.args.programName,
                                     season: ViewBrowser.currentView.args.seasonNumber } );
        }
    }

    XmlListModelStatusMessage { target: programModel }
}
