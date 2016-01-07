import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
title: 'Informazioni'
page: Page{id:this_page
    Flickable{
        anchors.fill:parent
        contentHeight: info.paintedHeight + 20
        contentWidth: parent.width
        Text{
            anchors.margins:10
            id:info
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.top:parent.top
            wrapMode:Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: '<h3>Versione 1.0.2</h3>
                    <h1>Sviluppato da <a target="_blank" href="http://dakation.altervista.org/">DPD-</a>
                    <br>Rilasciato sottolicenza GNU/GPL2: <a target="_blank" href="https://github.com/DPDmancul/OsmerArpaFVG">Sorgente</a></h1>
                    <h2>Previsione a cura dell\' <a target="_blank" href="http://www.meteo.fvg.it/">OSMER Arpa F.V.G.</a></h2>'
            onLinkActivated: Qt.openUrlExternally(link)
        }

        Image{
            source:'https://www.paypalobjects.com/it_IT/IT/i/btn/btn_donate_LG.gif'
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:info.bottom
            anchors.margins:10
            MouseArea{
                anchors.fill:parent
                height: 40
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=96Z5JHZ8EEYK2')
            }
        }
    }
}}
