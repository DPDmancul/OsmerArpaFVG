import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import "Pages"

MainView {
    objectName: "mainView"
    id:mainview
    applicationName: "osmerarpafvg.dpd-"

    property var db

    Timer {
        id:updateTimer
        property int minutes: 120
            interval: 60000*minutes;
            running: true;
            repeat: true
            onTriggered: upDate(db)
        }


    function load (db){
        previsioni.page.load(db)
        info.load_time(db)
    }

    function settime(db){
        db.transaction(
            function(tx) {
                tx.executeSql('UPDATE LastUp SET last=CURRENT_TIMESTAMP WHERE id=1');
            }
        )
    }

    function upDate (db){
        previsioni.page.updateAllTexts(db)
        load(db)
        console.log('Aggiornamento dati...')
        settime(db)
    }

    function firsttime(db){
        db.transaction(
                        function(tx) {
                            tx.executeSql('CREATE TABLE IF NOT EXISTS Previsioni(id TINYINT UNSIGNED,situazione TEXT, oggi TEXT, domani TEXT, dopodomani TEXT, piu3 TEXT, piu4 TEXT)');
                            tx.executeSql('INSERT INTO Previsioni VALUES (1,\'situazione\', \'oggi\', \'domani\' , \'dopodomani\' , \'piu3\' , \'piu4\')');
                            tx.executeSql('CREATE TABLE IF NOT EXISTS Img_previsioni(id TINYINT UNSIGNED,situazione BLOB, oggi BLOB, domani BLOB, dopodomani BLOB, piu3 BLOB, piu4 BLOB)');
                            tx.executeSql('INSERT INTO Img_previsioni VALUES (1,\'situazione\', \'oggi\', \'domani\' , \'dopodomani\' , \'piu3\' , \'piu4\')');
                            tx.executeSql('CREATE TABLE IF NOT EXISTS lastUp(id TINYINT UNSIGNED,last DATETIME,every INT UNSIGNED)');
                            tx.executeSql('INSERT INTO LastUp VALUES (1,CURRENT_TIMESTAMP,120)');
                        }
                    )
        upDate(db)
        db.changeVersion("", "2.0.0");
    }

    function checktime(db){
        db.transaction(
            function(tx) {
                var rs=tx.executeSql('SELECT * FROM LastUp WHERE (strftime(\'%s\',\'now\') - strftime(\'%s\',last)) >= ?', [updateTimer.interval/1000]);
                if (rs.rows.length>0)
                    upDate(db)
            }
        )
    }

    Component.onCompleted: {
         db = LocalStorage.openDatabaseSync("OsmerArpaFVG_v2", "2.0.0", "meteo data for Osmer Arpa FVG app", 1000000, firsttime)
         checktime(db)
         load(db)
    }

    automaticOrientation: true

    backgroundColor: pageStack.currentPage.currentPage.cBackground
    headerColor: (pageStack.currentPage.currentPage.parent===previsioni?previsioni.page.headerColor:backgroundColor)

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(150)
    height: units.gu(75)

   PageStack {
            id: pageStack
            Component.onCompleted: push(rootTabs)            
            anchors.fill: parent
            Tabs {
                      id: rootTabs
                      anchors.fill: parent
                Previsioni{id:previsioni}
                Info{id:info}
            }

    }

}

