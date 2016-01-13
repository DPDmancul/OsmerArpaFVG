import QtQuick 2.0

Rectangle{
    property int leftp
    property int topp
    property int zone
    color:'transparent'
    border.color: 'blue'
    border.width: this_page.zona===zone?2:0
    radius: 10
    x:leftp*imgine.height/100
    y:topp*imgine.height/100
    width:15 *imgine.height/100
    height: width
    z:100
    MouseArea{
        anchors.fill: parent
        onClicked: {this_page.zona = parent.zone
            this_page._load_zone(this_page.head.sections.selectedIndex)
            mouse.accepted = true}
    }
}

