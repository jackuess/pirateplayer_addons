import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    id: list

    model: XmlListModel {
        id: seasonModel

        onStatusChanged: {
            if (status === XmlListModel.Ready && seasonModel.count < 1) {
                ViewBrowser.loadView( Qt.resolvedUrl("program.qml"),
                                     { url: decodeURIComponent(seasonModel.source),
                                         programName: ViewBrowser.currentView.args.programName,
                                         needsNSDecl: true },
                                     true );
            }
        }

        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/1999/xhtml';"
        source: ViewBrowser.currentView.args.url
        query: '//div[@class="k5-tab selected"]/table//div[@class="buttons"]/div'

        XmlRole {
            name: "seasonNumber"
            query: "text()[1]/string()"
        }
        XmlRole {
            name: "link"
            query: "span/string()"
        }
    }
    delegate: ListDelegate {
        text: "Säsong " + model.seasonNumber

        onClicked: {
            ViewBrowser.currentView.state = { currentIndex: list.currentIndex };
            ViewBrowser.loadView( Qt.resolvedUrl("program.qml"),
                                 { url: "tidy://www.kanal9play.se" + model.link,
                                     programName: ViewBrowser.currentView.args.programName,
                                     seasonNumber: model.seasonNumber,
                                     needsNSDecl: false } );
//            var newFactory = {
//                loader: currentView,
//                url: "tidy://www.kanal9play.se" + model.link,
//                source: Qt.resolvedUrl("program.qml"),
//                callback: function () {
//                    this.loader.source = this.source;
//                    this.loader.item.model.source = this.url;
//                }};
//            ViewStack.pushFactory(newFactory);
        }
    }

    XmlListModelStatusMessage { target: seasonModel }
}
