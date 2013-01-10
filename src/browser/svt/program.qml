import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

CustomListView {
    id: svtProgram

    property string programName
    model: XmlListModel {
        id: programModel
        query: '//div[@data-tabname="episodes" or @data-tabname="recommended"]//article'

        onStatusChanged: svtProgram.statusChanged(programModel.status)

        XmlRole {
            name: "text"
            //query: "div/header/h5/string()"
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
    delegate: ListItem {
        text: model.text.slim()
        imgSource: model.thumb.startsWith("http://") ? model.thumb : "http://svtplay.se" + model.thumb
        onClicked: {
            ViewStack.piratePlay( "http://svtplay.se" + model.link,
                                  { title: model.text,
                                    name: svtProgram.programName } );
        }
    }
}
