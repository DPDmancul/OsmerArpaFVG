import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
                title: 'Previsioni'
                page: Page{id:this_page
    property color cBackground:"#EDEDED"//Theme.palette.normal.background
    property color headerColor:cBackground
    property bool landscape: height<(parent.width-400)
    property variant names: ["situazione","oggi","domani","dopodomani","piu3","piu4"]
    property variant texts:["","","","","",""]
    property int zona:0
    head {
          sections {
              onSelectedIndexChanged: zona=0
              model: [this.head.sections.selectedIndex==0?"Situazione":"Sit", this.head.sections.selectedIndex==1?"Oggi":"Oggi", this.head.sections.selectedIndex==2?"Domani":"Dom", this.head.sections.selectedIndex==3?"Dopodomani":"Dop",this.head.sections.selectedIndex==4?"3 giorni":"3 g",this.head.sections.selectedIndex==5?"4 giorni":"4 g"]
           }
        }
    function updateText(url,i,db) {
              var doc = new XMLHttpRequest()
              doc.onreadystatechange = function() {
                  if (doc.readyState === XMLHttpRequest.DONE){
                      texts[i] = doc.responseText
                      db.transaction(
                          function(tx) {
                              tx.executeSql('UPDATE Previsioni SET `'+names[i]+'`=?', [ texts[i] ])
                          }
                      )
                  }
              }
              doc.open("get", url)
              doc.setRequestHeader("Content-Encoding", "UTF-8")
              doc.send()
          }
    function updateAllTexts(db) {
        for (var x in names)
            updateText('http://dakation.altervista.org/meteo/server/previsioni_2.php?q='+names[x],x,db)
    }
    function load(db) {
              db.transaction(
                  function(tx) {
                      var rs = tx.executeSql('SELECT * FROM Previsioni WHERE id=1')
                      texts[0] = rs.rows.item(0).situazione
                      texts[1] = rs.rows.item(0).oggi
                      texts[2] = rs.rows.item(0).domani
                      texts[3] = rs.rows.item(0).dopodomani
                      texts[4] = rs.rows.item(0).piu3
                      texts[5] = rs.rows.item(0).piu4
                  }
              )

        //%to-add%/QUI è da inserie un codice che ricarichi il testo del Text in previsioni
          }

Flickable{
    anchors.fill:parent
    contentWidth:parent.width
    contentHeight: this_page.landscape?parent.height-90:imgine.height+mainText.paintedHeight+30 //90 è la misura dell'header
    flickableDirection:Flickable.VerticalFlick
    interactive : !this_page.landscape
    UbuntuShape {
        id:imgine
        backgroundColor:this_page.cBackground
        anchors.top:parent.top
        anchors.left:parent.left
        height: (this_page.landscape?parent.height:parent.width)-10
        width:height
        anchors.margins:5
        source: Image {
            source: "http://dakation.altervista.org/meteo/server/image_2.php?png="+this_page.names[this_page.head.sections.selectedIndex]
        }
        Item{
            enabled:this_page.head.sections.selectedIndex>0 && this_page.head.sections.selectedIndex < 4
            visible:enabled
            //mappa
            anchors.fill:imgine
            z:99
          MiniMap{leftp :28;topp: 7;zone: 1}
          MiniMap{leftp :68;topp: 3;zone: 2}
          MiniMap{leftp :17;topp: 27;zone: 3}
          MiniMap{leftp :52;topp: 23;zone: 4}
          MiniMap{leftp :15;topp: 51;zone: 7}
          MiniMap{leftp :44;topp: 46;zone: 6}
          MiniMap{leftp :67;topp: 55;zone: 7}
          MiniMap{leftp :80;topp: 78;zone: 8}
          MiniMap{leftp :45;topp: 72;zone: 8}
          MiniMap{leftp :45;topp: 7;zone: 5}//monti
          MiniMap{leftp :34;topp: 24;zone: 5}//monti
            MouseArea{
                anchors.fill: parent
                onClicked: this_page.zona = 0
            }
        }
    }
    Flickable{
        anchors.right:parent.right
        anchors.left:this_page.landscape?imgine.right:parent.left
        anchors.top:this_page.landscape?parent.top:imgine.bottom
        anchors.bottom:parent.bottom
        contentHeight: mainText.paintedHeight
        //height:landscape?parent.height:paintedHeight
        flickableDirection:Flickable.VerticalFlick
        interactive: this_page.landscape
        Text{
            id:mainText
            text: JSON.parse(this_page.texts[this_page.head.sections.selectedIndex])[this_page.zona]
            anchors.fill:parent
            wrapMode:Text.Wrap
            horizontalAlignment: Text.AlignJustify
            anchors.margins:20
        }
      }
   }
}
}
