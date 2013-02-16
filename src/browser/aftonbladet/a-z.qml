import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

AzListView {
    id: list

    model: XmlListModel {
        source: "tidy://www.aftonbladet.se/webbtv/"
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/1999/xhtml';"
        query: '//*[@id="abNavProgrambox"]/div/ul/li[@class="level1"]/a'

        XmlRole {
            name: "text"
            query: "string()"
        }
        XmlRole {
            name: "link"
            query: "@href/string()"
        }
    }
    delegate: ListDelegate {
        text: model.text.slim()

        onClicked: {
            ViewBrowser.currentView.state = { currentIndex: list.currentIndex };
            ViewBrowser.loadView( Qt.resolvedUrl("program.qml"),
                                 { url: model.link.replace('http://', 'tidy://'),
                                     programName: model.text.slim() } );
        }
    }
}
