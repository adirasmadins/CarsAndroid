import QtQuick 2.5

Item {
    id: carView
    property var list: carList
    property var area: area
    anchors.fill: parent

    SwipeArea {
        id: mouse
        menu: menuView
        anchors.fill: parent
        onMove: {
            console.log("onMove...")
            area.enabled = false
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            console.log("onSwipe...")
            mainArea.menuChange()
        }
        onCanceled: {
            console.log("onCanceled...")
            menuView.currentIndexChanged()
            normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
            area.enabled = menuView.currentIndex === 1 ? true : false
        }
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))

        Component {
            id: carDelegate
            Item { id: carItem; height: area.areaHeight*.3; width: parent.width; property string sourceImage: (status === false)? "images/images/free.png" : "images/images/rented.png";

                Text { id: carName; height: parent.height * .15
                    anchors { left: parent.left; leftMargin: 5; top: parent.top;}
                    color: "gray"; font.pixelSize: screenH/30; text: brand + " " + model
                }
                Text { id: license; height: parent.height * .1
                    anchors { left: parent.left; leftMargin: 5; top: carName.bottom;}
                    color: "gray"; font.pixelSize: screenH/35; text: licensePlate
                }
                Image { id: carImage; height: parent.height * .7
                    fillMode: Image.PreserveAspectFit
                    source: "images/"+photoPath
                    anchors { left: parent.left; top: license.bottom; topMargin: 5 }
                }
                Image { id: statusImage; height: parent.height * .3; width: statusImage.height
                    fillMode: Image.PreserveAspectFit
                    source: sourceImage
                    anchors { right: parent.right; top: parent.top; topMargin: 5}
                }

                ActionButton {
                    id: rsrvBtn; height: carItem.height * .3; width: rsrvBtn.height * 1.7
                    buttonText: qsTr("Rezerwuj")
                    anchors { bottom: parent.bottom; bottomMargin: 10; right: parent.right }
                    enabled: menuView.currentIndex === 1 ? true : false
                    z: carView.z + 1 // before parent
                    onActivated: { bookingView.setListIndex(listIndex); stackView.push(bookingView) }
                }

                ActionButton {
                    id: rentBtn; height: parent.height * .3; width: rsrvBtn.height * 1.7;
                    gradcolorStart: status === false ? "#00BE00" : "red"
                    gradcolorEnd: status === false ? "#009600" : "red"
                    buttonText: status === false ? qsTr("Wypożyczyć") : qsTr("Oddaj")
                    anchors { bottom: parent.bottom; bottomMargin: 10; right: rsrvBtn.left; rightMargin: 5 }
                    enabled: menuView.currentIndex === 1 ? true : false
                    z: carView.z + 1 // before parent
                    onActivated: { rentView.setListIndex(listIndex); stackView.push(rentView) }
                }

                Rectangle { height: 2; width: parent.width;
                    anchors { left: parent.left; horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                    color: "lightgray";
                }

           } // Item

        } // Component

        ListView {
           id: carList
           anchors.fill: parent
           model: carViewClass.carList
           delegate: carDelegate
           highlightMoveDuration: 0
        }

    } // Rectangle

} // Item
