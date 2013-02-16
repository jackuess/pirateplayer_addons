import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    model: XmlListModel {
        id: indexModel

        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/1999/xhtml';"
        source: ViewBrowser.currentView.args.url
        query: '//*[@id="abArtikelytaContainer"]/div[@class="abLinkBlock"][position() <= 2]//div[@class="abTeaser"]'

        XmlRole {
            name: "title"
            query: 'div//span[@class="abLink"]/a/string()'
        }
        XmlRole {
            name: "description"
            query: 'div[@class="abTeaserText"]/text()[2]/string()'
        }
        XmlRole {
            name: "thumb"
            query: "span//img/@src/string()"
        }
        XmlRole {
            name: "link"
            query: 'div//span[@class="abLink"]/a/@href/string()'
        }
    }
    delegate: ListDelegate {
        imgSource: decodeURIComponent(model.thumb)
        text: model.title.slim() + " - <small>" + model.description.slim() + "</small>"

        onClicked: {
            ViewBrowser.piratePlay( model.link,
                                 { title: model.title.slim(),
                                     description: model.description.slim(),
                                     name: ViewBrowser.currentView.args.programName } );
        }
    }

    XmlListModelStatusMessage { target: indexModel }
}
