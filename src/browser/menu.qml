import QtQuick 1.1

import "viewstack.js" as ViewStack

CustomListView {
    id: list

    model: ListModel {
        ListElement {
            title: "SVT-play"
            module: "svt"
            logo: "http://www.svtplay.se/public/2012.54/images/svt-play-2x.png"
        }
        ListElement {
            title: "TV3-play"
            module: "tv3"
            logo: "http://images2.wikia.nocookie.net/__cb20091126144517/logopedia/images/c/c6/TV3_logo_1990.png"
        }
        ListElement {
            title: "TV4-play"
            module: "tv4"
            logo: "http://images1.wikia.nocookie.net/__cb20100305140436/logopedia/images/3/31/TV4_Play.svg"
        }
        ListElement {
            title: "Kanal5-play"
            module: "kanal5"
            logo: "http://images2.wikia.nocookie.net/__cb20091126112949/logopedia/images/1/14/Kanal_5.svg"
        }

        ListElement {
            title: "TV6-play"
            module: "tv6"
            logo: "http://www.tv6play.se/themes/play/images/tv6-logo.png"
        }
        ListElement {
            title: "TV8-play"
            module: "tv8"
            logo: "http://www.viasat.se/sites-paytv/viasat.se/files/kanal8_play_0.png"
        }
//        ListElement {
//            title: "Kanal 9-play"
//            module: "kanal9"
//            logo: "http://www.kanal9play.se/themes/kanal9/images/logo.png"
//        }
        ListElement {
            title: "Aftonbladet-TV"
            module: "aftonbladet"
            logo: "http://www.tv14.net/wp-content/uploads/2010/10/Aftonbladet.jpg"
        }
    }

    delegate: ListItem {
        imgSource: model.logo
        text: model.title

        onClicked: {
            ViewStack.currentFactory = {
                view: Qt.resolvedUrl("menu.qml"),
                loader: currentView,
                callback: function (loader) {
                    this.loader.source = this.view;
                }};
            var newFactory = {
                source: Qt.resolvedUrl(model.module + "/initial.qml"),
                loader: currentView,
                callback: function () {
                    this.loader.source = this.source;
                }
            };
            ViewStack.pushFactory(newFactory);
        }
    }
}
