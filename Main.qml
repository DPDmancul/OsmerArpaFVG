import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import "Pages"

MainView {
    objectName: "mainView"
    id:mainview
    applicationName: "osmerarpafvg.dpd-"

    function firsttime(db){
        db.transaction(
                        function(tx) {
                            tx.executeSql('CREATE TABLE IF NOT EXISTS Previsioni(id TINYINT UNSIGNED,situazione TEXT, oggi TEXT, domani TEXT, dopodomani TEXT, piu3 TEXT, piu4 TEXT)');
                            tx.executeSql('INSERT INTO Previsioni VALUES (1,\'situazione\', \'oggi\', \'domani\' , \'dopodomani\' , \'piu3\' , \'piu4\')');
                            tx.executeSql('CREATE TABLE IF NOT EXISTS Img_previsioni(id TINYINT UNSIGNED,situazione BLOB, oggi BLOB, domani BLOB, dopodomani BLOB, piu3 BLOB, piu4 BLOB)');
                        }
                    )
        previsioni.updateAllTexts(db)
        db.changeVersion("", "2.0.0");
    }

    Component.onCompleted: {
         var db = LocalStorage.openDatabaseSync("OsmerArpaFVG_v2", "2.0.0", "meteo data for Osmer Arpa FVG app", 1000000, firsttime)
         previsioni.load(db)
    }

    automaticOrientation: true

    backgroundColor: pageStack.currentPage.cBackground
    headerColor: (pageStack.currentPage==previsioni?previsioni.headerColor:backgroundColor)

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(150)
    height: units.gu(75)

    PageStack {
            id: pageStack
            Component.onCompleted: push(previsioni)

            Previsioni{id:previsioni}

    }
}

