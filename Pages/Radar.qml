import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
title: 'Radar'

page: Page{id:this_page
    property color cBackground: '#FBECE7'

    Image {
        anchors.fill:parent
        fillMode: Image.PreserveAspectFit
        source: previsioni.page.readyimg?previsioni.page.images[6]:'loading.png'
    }

}}

