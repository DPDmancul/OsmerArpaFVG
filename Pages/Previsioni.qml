import QtQuick 2.0
import Ubuntu.Components 1.2

Page{id:this_page
    property color cBackground:"#EDEDED"//Theme.palette.normal.background
    property color headerColor:cBackground
    property bool landscape: height<(parent.width-400)
    property variant names: ["situazione","oggi","domani","dopodomani","piu3","piu4"]
    property variant texts:["","","","","",""]
    visible: false
    title: i18n.tr("Previsioni")
    head {
          sections {
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
          }

Flickable{
    anchors.fill:parent
    contentWidth:parent.width
    contentHeight: landscape?parent.height-90:imgine.height+mainText.paintedHeight+30 //90 è la misura dell'header
    flickableDirection:Flickable.VerticalFlick
    interactive : !landscape
    UbuntuShape {
        id:imgine
        backgroundColor:cBackground
        anchors.top:parent.top
        anchors.left:parent.left
        height: (landscape?parent.height:parent.width)-10
        width:height
        anchors.margins:5
        source: Image {
            source: "http://dakation.altervista.org/meteo/server/image_2.php?png="+names[this_page.head.sections.selectedIndex]
        }
    }
    Flickable{
        anchors.right:parent.right
        anchors.left:landscape?imgine.right:parent.left
        anchors.top:landscape?parent.top:imgine.bottom
        anchors.bottom:parent.bottom
        contentHeight: mainText.paintedHeight
        //height:landscape?parent.height:paintedHeight
        flickableDirection:Flickable.VerticalFlick
        interactive: landscape
        Text{
            id:mainText
            text: JSON.parse(texts[this_page.head.sections.selectedIndex]).general
            anchors.fill:parent
            wrapMode:Text.Wrap
            horizontalAlignment: Text.AlignJustify
            anchors.margins:20
        }
      }
   }
}
