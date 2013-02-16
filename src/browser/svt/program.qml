import QtQuick 1.1
import Components 1.0

import "../viewbrowser.js" as ViewBrowser
import "../common.js" as Common

PirateListView {
    property int status: XmlListModel.Loading

    anchors.fill: parent

    Component.onCompleted: {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                status = XmlListModel.Ready;
                programModel.xml = doc.responseText.replace("<![if !(lte IE 7)]>", "").replace("<![endif]>", "");
            }
        }
        doc.open("GET", ViewBrowser.currentView.args.url);
        doc.send();
    }

    model: XmlListModel {
        id: programModel

        query: '//div[@data-tabname="episodes" or @data-tabname="recommended"]//article'

        XmlRole {
            name: "text"
            query: "@data-title/string()"
        }
        XmlRole {
            name: "link"
            query: "div/a[1]/@href/string()"
        }
        XmlRole {
            name: "thumb"
            query: "div//img/@src/string()"
        }
    }

    delegate: ListDelegate {
        imgSource: model.thumb.startsWith("http://") ? model.thumb : "http://svtplay.se" + model.thumb
        text: model.text.slim()
        onClicked: {
            ViewBrowser.piratePlay( "http://svtplay.se" + model.link,
                                  { title: model.text,
                                    name: ViewBrowser.currentView.args.programName } );
        }
    }

    XmlListModelStatusMessage { target: parent }
}
