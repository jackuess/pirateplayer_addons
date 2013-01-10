import QtQuick 1.1

ListView {
    id: list
    height: 1

    signal statusChanged(int newStatus)

    onContentHeightChanged: {
        progress.state = "Ready"
        if (contentHeight > 0) {
            list.statusChanged(XmlListModel.Ready)
            height = contentHeight
            //parent.height = contentHeight;
        }
    }
}
