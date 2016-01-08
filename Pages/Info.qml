import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
title: 'Informazioni'

function load_time(db){
    db.transaction(
        function(tx) {
            var rs=tx.executeSql('SELECT every FROM LastUp WHERE id=1')
            minut.text=rs.rows[0].every
        }
    )
}

page: Page{id:this_page
    property color cBackground: 'azure'

    Flickable{
        anchors.fill:parent
        contentHeight: info.paintedHeight + 140
        contentWidth: parent.width
        Text{
            anchors.margins:10
            id:info
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.top:parent.top
            wrapMode:Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: '<h3>Versione 2.0.2</h3>
                    <h1>Sviluppato da <a target="_blank" href="http://dakation.altervista.org/">DPD-</a>
                    <br>Rilasciato sottolicenza GNU/GPL2: <a target="_blank" href="https://github.com/DPDmancul/OsmerArpaFVG">Sorgente</a></h1>
                    <h2>Previsione a cura dell\' <a target="_blank" href="http://www.meteo.fvg.it/">OSMER Arpa F.V.G.</a></h2>'
            onLinkActivated: Qt.openUrlExternally(link)
        }
        Item{
            id:settings
            anchors.top:info.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins:10
            height:25
            width:label1.width+minut.width+label2.width+20
            Label{id:label1;text:'Aggiorna meteo ogni: '}
            TextField{id:minut
                width:100
                anchors.left:label1.right
                anchors.verticalCenter: label1.verticalCenter
                anchors.leftMargin: 10
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: IntValidator{bottom:60}}
            Label{id:label2;anchors.left:minut.right;anchors.leftMargin: 10;text:'minuti'}
        }
 Item{
     id:btns
     anchors.top:settings.bottom
     anchors.margins:10
     anchors.horizontalCenter: parent.horizontalCenter
     width: update_btn.width+btn_save.width+10
     height:40

     Button{text:'Imposta';id:btn_save
             enabled:minut.acceptableInput
             color:enabled?'green':'gray'
             onClicked: mainview.db.transaction(
                    function(tx) {
                        tx.executeSql('UPDATE LastUp SET every=? WHERE id=1' , [ minut.text ])
                    }
                )
             }
        Button{
                anchors.left:btn_save.right
                id:update_btn
                anchors.leftMargin:10
                text:'Aggiorna ora'
                color:'blue'
                onClicked: mainview.upDate(mainview.db)}
       }
        Image{
            source:'https://www.paypalobjects.com/it_IT/IT/i/btn/btn_donate_LG.gif'
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:btns.bottom
            anchors.margins:10
            MouseArea{
                anchors.fill:parent
                height: 40
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=96Z5JHZ8EEYK2')
            }
        }
    }
}}
