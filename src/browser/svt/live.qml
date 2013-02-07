import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: svtProgram

    Component.onCompleted: {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE)
                programModel.xml = doc.responseText.replace("<![if !(lte IE 7)]>", "").replace("<![endif]>", "");
        }
        doc.open("GET", "tidy://svtplay.se/kanaler");
        doc.send();
    }

    model: XmlListModel {
        id: programModel
        query: '//div[@class="svtTabMenu playChannelMenu"]//li/a'

        onStatusChanged: svtProgram.statusChanged(programModel.status)

        XmlRole {
            name: "channel"
            //query: "@data-channel/string()"
            query: "div/img[1]/@alt/string()"
        }
        XmlRole {
            name: "title"
            query: "div/span[@class=\"playChannelMenuTitle\"]/string()"
        }

        XmlRole {
            name: "link"
            query: "@href/string()"
        }
        XmlRole {
            name: "thumb"
            query: "div/img[1]/@src/string()"
        }
    }
    delegate: ListItem {
        text: "<strong>" + model.channel.slim() + "</strong><br /><small>" + model.title + "</small>"
        imgSource: "http://svtplay.se" + model.thumb
        onClicked: {
            ViewStack.piratePlay( "http://svtplay.se" + model.link,
                                  { title: model.title,
                                    name: model.channel } );
        }
    }
}
