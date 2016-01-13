import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
title: 'Radar'

page: Page{id:this_page
    property color cBackground: '#FBECE7'
    property string imageuri:'loading.png'


    Image {
        id:radarimage
        anchors.fill:parent
        fillMode: Image.PreserveAspectFit
        source: this_page.imageuri
    }

}}

