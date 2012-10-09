import QtQuick 1.1

import "../common.js" as Common

import ".."

Item {
    id: list

    signal statusChanged(int newStatus)

    property alias url: programModel.source
    property string programName

    XmlListModel {
        id: programModel
        query: "//form[@class=\"search-state-form\"]"

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                episodesList.model.source = "tidy://www.tv4play.se/search?order=desc&amp;rows=1000&amp;sorttype=date&amp;video_types=programs&amp;categoryids=" + get(0).categoryId;
            }
        }

        XmlRole {
            name: "categoryId"
            query: "input[@name=\"categoryids\"]/@value/string()"
        }
    }
    ListView {
        id: episodesList
        height: 1; width: parent.width
        onContentHeightChanged: {
            if (contentHeight > 0) {
                height = contentHeight;
                parent.height = contentHeight;
            }
        }
        model: XmlListModel {
            onStatusChanged: list.statusChanged(status)

            query: "//li[starts-with(@class, \"video-panel clip\") and not(descendant::p[@class='premium'])]"

            XmlRole {
                name: "text"
                query: "div/h3[@class=\"video-title\"]/a/string()"
            }
            XmlRole {
                name: "link"
                query: "div/h3[@class=\"video-title\"]/a/@href/string()"
            }
            XmlRole {
                name: "date"
                query: "div/div[@class=\"video-meta\"]/p[@class=\"date\"]/string()"
            }
            XmlRole {
                name: "image"
                query: "p[@class=\"video-picture\"]/a/img/@src/string()"
            }
        }
        delegate: ListItem {
            height: 70
            fontPixelSize: 15
            gradient: Gradient {
                GradientStop { position: 0.0; color: ["#555","#333"][model.index%2] }
                GradientStop { position: 1.0; color: ["#111","#777"][model.index%2] }
            }
            imgSource: {
                var url = model.image;
                var pairs = url.split("&amp;");
                for (var i=0; i<pairs.length; i++) {
                    var pair = pairs[i].split("=");
                    if (pair[0] === "source")
                        return pair[1];
                }
            }
            text: model.text.slim() + "<br/>" + model.date

            onClicked: {
                mainWindow.getStreams( model.link,
                                      { title: model.text.slim(),
                                        name: list.programName,
                                        time: model.date} );
            }
        }
    }
}
