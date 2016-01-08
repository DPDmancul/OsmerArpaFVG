import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
title: 'Webcams'


page: Page{id:this_page
    property color cBackground: 'lightyellow'

    head.actions:Action {
            iconName: "close"
            visible:phviewer.visible
            onTriggered: {
                phviewer.visible=false
            }
        }

    ListModel {
        id: webel

        ListElement {
            name: 'Barcis'
            url: 'title'
        }
        ListElement {
            name: 'Barcis'
            url: 'http://www.osmer.fvg.it/webcam/img/20140918/201409181300_barcis.jpg'
        }ListElement {
            name: 'Cervignano del Friuli'
            url: 'title'
        }ListElement {
            name: 'Villa Chiozza'
            url: 'http://www.turismofriuliveneziagiulia.it/webcam/villa_chiozza.jpg'
        }ListElement {
            name: 'Claut'
            url: 'title'
        }ListElement {
            name: 'Claut'
            url: 'http://www.osmer.fvg.it/webcam/img/20140918/201409181301_claut.jpg'
        }
        ListElement {
        name: 'Forni di Sopra'
        url: 'title'
        }ListElement {
        name: 'Campo Scuola Davost (880 mt.)'
        url: 'http://promotur.digitalwebland.com/webcam/davost.jpg.ashx?height=700&amp;quality=75&amp;speed=2'
        }ListElement {
        name: 'Grado'
        url: 'title'
        }ListElement {
        name: 'Ingresso principale della spiaggia'
        url: 'http://www.osmer.fvg.it/webcam/img/20140918/201409181301_grado.jpg'
        }ListElement {
        name: 'Lignano Sabbiadoro'
        url: 'title'
        }ListElement {
        name: 'Lignano Terrazzamare'
        url: 'http://www.lignanosabbiadoro.com/images/webcam1.jpg'
        }ListElement {
        name: 'Pordenone'
        url: 'title'
        }ListElement {
        name: 'Pordenone'
        url: 'http://webcam.comune.pordenone.it/pordenone.jpg'
        }ListElement {
        name: 'Ravascletto/Zoncolan'
        url: 'title'
        }ListElement {
        name: 'Zoncolan'
        url: 'http://www.osmer.fvg.it/webcam/img/20140918/201409181300_zoncolan.jpg'
        }ListElement {
        name: 'Tarvisio'
        url: 'title'
        }ListElement {
        name: 'Campo Scuola (770 mt.)'
        url: 'http://promotur.digitalwebland.com/webcam/camposcuola3.jpg.ashx?height=600'
        }ListElement {
        name: 'Tramonti di Sotto'
        url: 'title'
        }ListElement {
        name: 'Tramonti di Sotto'
        url: 'http://www.turismofvg.it/ProxyVFS.axd?snode=42123&amp;stream'
        }ListElement {
        name: 'Udine'
        url: 'title'
        }ListElement {
        name: 'Piazza Primo Maggio'
        url: 'http://www.turismofriuliveneziagiulia.it/webcam/udine.jpg'
        }

    }

      ListView {
          anchors.fill:parent
           anchors.margins: 20
           id:elenco
           height: (webel.count+1)*25
           model: webel
           delegate: Label {
               height:25
               width:parent.width
               anchors.left: parent.left
               font.bold:url=='title'
               font.pixelSize: 20
               anchors.leftMargin: url=='title'?0:20
               text: name
               MouseArea{
                anchors.fill:parent
                enabled: !parent.font.bold
                onClicked: {
                    phcam.source=url
                    phviewer.visible=true
                }
               }
           }
       }

    Rectangle{
           id:phviewer
           z:100
           anchors.fill:parent
           color:'black'
           opacity:0.8
           visible: false
           MouseArea{
               anchors.fill:parent
           }
           Icon {
                       name: "close"
                       width: 20
                       anchors.top:parent.top
                       anchors.right: parent.right
                       anchors.margins: 15
                       MouseArea{
                           anchors.fill:parent
                           onClicked: {
                           phviewer.visible=false
                          }
                       }
                   }
       }
    Image {
        z:101
        visible: phviewer.visible
        anchors.fill:parent
        fillMode: Image.PreserveAspectFit
        id: phcam
        source: ""
    }
}}
