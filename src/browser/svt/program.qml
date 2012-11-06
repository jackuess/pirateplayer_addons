import QtQuick 1.1

import "../viewstack.js" as ViewStack
import "../common.js" as Common
import ".."

ListView {
    id: svtProgram

    property string programName
    signal statusChanged(int newStatus)

    height: 1
    onContentHeightChanged: if (contentHeight > 0) height = contentHeight
    spacing: 0
    model: XmlListModel {
        id: programModel
        query: '//div[@data-tabname="episodes"]//article'

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
        height: 70

        gradient: Gradient {
            GradientStop { position: 0.0; color: ["#555","#333"][model.index%2] }
            GradientStop { position: 1.0; color: ["#111","#777"][model.index%2] }
        }

        fontPixelSize: 20
        text: model.text.slim()
        imgSource: model.thumb.startsWith("http://") ? model.thumb : "http://svtplay.se" + model.thumb
        onClicked: {
			mainWindow.getStreams( "http://svtplay.se" + model.link,
								  { title: model.text,
                                    name: svtProgram.programName } );
        }
    }
}
