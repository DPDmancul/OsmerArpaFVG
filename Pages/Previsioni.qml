import QtQuick 2.0
import Ubuntu.Components 1.2

Page{id:this_page
    property color cBackground:"#EDEDED"//Theme.palette.normal.background
    property color headerColor:cBackground
    property bool landscape: height<(parent.width-400)
    property variant names: ["situazione","oggi","domani","dopodomani","piu3","piu4"]
    visible: false
    title: i18n.tr("Previsioni")
    head {
          sections {
              //è da richiamare quest funzione anche all'avvio
               onSelectedIndexChanged: setText('http://dakation.altervista.org/meteo/server/previsioni_2.php?q='+names[this.head.sections.selectedIndex]);
               model: [this.head.sections.selectedIndex==0?"Situazione":"Sit", this.head.sections.selectedIndex==1?"Oggi":"Oggi", this.head.sections.selectedIndex==2?"Domani":"Dom", this.head.sections.selectedIndex==3?"Dopodomani":"Dop",this.head.sections.selectedIndex==4?"3 giorni":"3 g",this.head.sections.selectedIndex==5?"4 giorni":"4 g"]
           }
        }

    function setText(url) {
          var doc = new XMLHttpRequest();
          doc.onreadystatechange = function() {
              if (doc.readyState == XMLHttpRequest.DONE) {
                  mainText.text = JSON.parse(doc.responseText).general;
              }
          }
          doc.open("get", url);
          doc.setRequestHeader("Content-Encoding", "UTF-8");
          doc.send();
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
            text: "Loading..."
            anchors.fill:parent
            wrapMode:Text.Wrap
            horizontalAlignment: Text.AlignJustify
            anchors.margins:20
        }
      }
   }
}
