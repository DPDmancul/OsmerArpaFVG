import QtQuick 2.0
import Ubuntu.Components 1.1
import "Pages"

MainView {
    objectName: "mainView"

    applicationName: "osmerarpafvg.dpd-"

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

