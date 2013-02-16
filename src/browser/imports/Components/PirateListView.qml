import QtQuick 1.1
import QtDesktop 0.1

import "../../viewbrowser.js" as ViewBrowser
import "../../common.js" as Common

Item {
    id: pirateListView

    property alias currentIndex: list.currentIndex
    property alias currentItem: list.currentItem
    property alias currentSection: list.currentSection
    property alias delegate: list.delegate
    property alias header: list.header
    property alias model: list.model
    property alias section: list.section

    function positionViewAtIndex (index, mode) { list.positionViewAtIndex(index, mode) }

    ListView {
        id: list

        property int previousIndex: 0

        onContentYChanged: if (moving) scrollBar.value = contentY
        onContentHeightChanged: if (contentHeight > 0 && ViewBrowser.currentView.state) currentIndex = ViewBrowser.currentView.state.currentIndex

        anchors { left: parent.left; right: scrollBar.left; top: parent.top; bottom: parent.bottom }

        focus: true
        keyNavigationWraps: true

        Keys.onReturnPressed: currentItem.clicked()

        Keys.onPressed: {
            var pageDown = currentIndex+10;
            var pageUp = currentIndex-10;
            if (event.key == Qt.Key_PageDown)
                currentIndex = pageDown >= count ? count-1 : pageDown;
            if (event.key == Qt.Key_PageUp)
                currentIndex = pageUp < 0 ? 0 : pageUp;
        }

        highlight: Rectangle {
            color: "#0099cc"
            radius: 3
            width: list.width

            onYChanged:  {
                var animationFinished = y == currentItem.y;
                if (list.contentY > scrollBar.value && animationFinished)
                    scrollBar.value = list.contentY + currentItem.height;
                else if (list.contentY < scrollBar.value && animationFinished)
                    scrollBar.value = list.contentY -currentItem.height;
            }
        }
        highlightMoveDuration: 500
    }


    ScrollBar {
        id: scrollBar

        onValueChanged: if (!list.moving && value > 0) list.contentY = value

        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }

        orientation: Qt.Vertical
        minimumValue: 0
        maximumValue: list.contentHeight > 0 ? list.contentHeight-list.height : 0
    }
}
