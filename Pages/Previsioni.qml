import QtQuick 2.0
import Ubuntu.Components 1.2

Tab {
                title: 'Previsioni'
                page: Page{id:this_page
    property color cBackground:"#EDEDED"//Theme.palette.normal.background
    property color headerColor:cBackground
    property bool landscape: height<(parent.width-400)
    property variant names: ["situazione","oggi","domani","dopodomani","piu3","piu4","radar"]
    property variant texts:["","","","","",""]
    property variant images:["","","","","","",""]
    property int zona:0
    head {
          sections {
              onSelectedIndexChanged: _load(this_page.head.sections.selectedIndex)
              model: [this.head.sections.selectedIndex==0?"Situazione":"Sit", this.head.sections.selectedIndex==1?"Oggi":"Oggi", this.head.sections.selectedIndex==2?"Domani":"Dom", this.head.sections.selectedIndex==3?"Dopodomani":"Dop",this.head.sections.selectedIndex==4?"3 giorni":"3 g",this.head.sections.selectedIndex==5?"4 giorni":"4 g"]
           }
        }


    function _reset(){
        mainText.text='Aggiornamento in corso...'
        radar.page.imageuri=cartina.source='loading.png'
    }
    function _load_zone(idx){
        try{
            mainText.text=JSON.parse(texts[idx])[zona]
           }catch(err) {
            console.log('_load_zone',err.message);
        }
    }
    function _load(idx){
        zona=0
        _load_zone(idx)
        cartina.source=images[idx]
    }
    function _load_all(){
       _load(this_page.head.sections.selectedIndex)
      radar.page.imageuri=images[6]
    }

    function updateText(url,i,db) {
              var doc = new XMLHttpRequest()
              doc.onreadystatechange = function() {
                  if (doc.readyState === XMLHttpRequest.DONE){
                      texts[i] = doc.responseText
                      db.transaction(
                          function(tx) {
                              tx.executeSql('UPDATE Previsioni SET `'+names[i]+'`=?', [ texts[i] ])
                              if(i===5)
                                  _load_all()
                          }
                      )
                  }
              }
              doc.open("get", url)
              doc.setRequestHeader("Content-Encoding", "UTF-8")
              doc.send()
          }
    function updateImage(url,i,db) {
              var doc = new XMLHttpRequest()
              doc.onreadystatechange = function() {
                  if (doc.readyState === XMLHttpRequest.DONE){
                      images[i] = doc.responseText
                      db.transaction(
                          function(tx) {
                              tx.executeSql('UPDATE Img_previsioni SET `'+names[i]+'`=?', [ images[i] ])
                              if(i===5)
                                _load_all()
                          }
                      )
                  }
              }
              doc.open("get", url)
              doc.setRequestHeader("Content-Encoding", "UTF-8")
              doc.send()
          }
    function updateAllTexts(db) {
        _reset()
        updateImage('http://dakation.altervista.org/meteo/server/image_2_b64.php?png=radar',6,db)
        for (var x=0;x<6;x++){
            updateText('http://dakation.altervista.org/meteo/server/previsioni_2.php?q='+names[x],x,db)
            updateImage('http://dakation.altervista.org/meteo/server/image_2_b64.php?png='+names[x],x,db)
        }
    }
    function load(db) {
        _reset()
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
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('SELECT * FROM Img_previsioni WHERE id=1')
                images[0] = rs.rows.item(0).situazione
                images[1] = rs.rows.item(0).oggi
                images[2] = rs.rows.item(0).domani
                images[3] = rs.rows.item(0).dopodomani
                images[4] = rs.rows.item(0).piu3
                images[5] = rs.rows.item(0).piu4
                images[6] = rs.rows.item(0).radar
            }
        )
        _load_all()
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
        height:(this_page.landscape?parent.height:parent.width)-10
        width:height
        anchors.margins:5
        source: Image {
            id:cartina
            source: 'loading.png'
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
                onClicked: {this_page.zona = 0
                this_page._load_zone(this_page.head.sections.selectedIndex)}
            }
        }
    }
    Flickable{
        anchors.right:parent.right
        anchors.left:this_page.landscape?imgine.right:parent.left
        anchors.top:this_page.landscape?parent.top:imgine.bottom
        anchors.bottom:parent.bottom
        contentHeight: mainText.paintedHeight
        flickableDirection:Flickable.VerticalFlick
        interactive: this_page.landscape
        Text{
            id:mainText
            text: 'Caricamento in corso...'
            anchors.fill:parent
            wrapMode:Text.Wrap
            horizontalAlignment: Text.AlignJustify
            anchors.margins:20
        }
      }
   }
}
}
