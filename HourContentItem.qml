import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQml 2.2
import QtGraphicalEffects 1.0
import Qt.labs.controls 1.0


Item {
    id: hourContentItem
    visible: dateChooserStack.currentItem === hourContentItem ? true : false
    property var nextView
    property bool isReserveButtonVisible : true

    Rectangle {
        id: hourContent
        color: "white"
        anchors.fill: parent

        ListView {
            id: entriesList
            anchors {left: parent.left; right: parent.right; top: parent.top; bottom: nextBtn.top; bottomMargin: 10}
            model: { if(carViewClass.carList.length) carViewClass.carList[listIndex].bookingInfoList; }
            delegate: entriesListDelegate
        }

        Component {
            id: entriesListDelegate
            Item { id: elDItem; height: entriesList.height * 0.35; width: parent.width;
                property bool codeVisible: true
                Rectangle { id: orangeRectangle
                    anchors { left: parent.left; leftMargin: 10; top: parent.top; topMargin: 5; verticalCenter: personName.verticalCenter}
                    height: 20
                    width: 20
                    color: "#FF8C00"
                    visible: elDItem.codeVisible
                }

                Rectangle {
                    id: codeRect; height: elDItem.height * .8; width: height*5;
                    anchors.centerIn: parent
                    color: "transparent"
                    visible: false

                    CustomTextField { id: code; height: parent.height *.5 - 10; width: parent.width;
                        anchors { top: parent.top }
                        horizontalAlignment: Text.AlignHCenter
                        placeholderText: "Kod anulowania"
                        maximumLength : 6
                        validator: IntValidator { bottom: 0; top: 999999 }
                        inputMethodHints: Qt.ImhDigitsOnly
                    }

                    ActionButton {
                        id: getCode; height: parent.height *.5; width: parent.width
                        anchors { top: code.bottom; topMargin: 10; }
                        buttonText: qsTr("Wklej ze schowka")
                        buttonColor: "lightgray"
                        onActivated: { code.field.text = ""; code.field.paste() }
                    }

                    Behavior on visible {
                        NumberAnimation {
                            target: codeRect
                            property: "opacity"
                            from: codeRect.visible === false ? 0 : 1
                            to: codeRect.visible === false ? 1 : 0
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }}
                }

                Image { id: deleteImage; height: orangeRectangle.height; width: height
                    anchors { right: parent.right; top: parent.top; topMargin: 5; }
                    fillMode: Image.PreserveAspectFit
                    cache: true
                    mipmap: true
                    smooth: true
                    antialiasing: true
                    source: "/images/images/deleteGray.png"

                    MouseArea {
                        anchors.fill:parent
                        onClicked: { deleteClickAnimation.running = true }
                    }

                    SequentialAnimation {
                        id: deleteClickAnimation
                        PropertyAnimation { target: deleteImage; property: "opacity"; easing.type: Easing.Linear; to: 0; duration: 10 }
                        PropertyAnimation { target: deleteImage; property: "opacity"; easing.type: Easing.Linear; to: 1; duration: 10 }
                        onRunningChanged: {
                            if (deleteClickAnimation.running) {}
                            else {
                               if(code.visible === false) {
                                   deleteImage.source = "/images/images/delete.png"
                                   codeRect.visible = true
                                   elDItem.codeVisible = false

                               }
                               else if(code.text === "")
                               {
                                   elDItem.forceActiveFocus()
                                   deleteImage.source = "/images/images/deleteGray.png"
                                   codeRect.visible = false
                                   elDItem.codeVisible = true
                               }
                               else {
                                   // DELETE RESERVATION
                               }
                            }
                        }
                    }
                }

                Text { id: personName
                    anchors { left: orangeRectangle.right; leftMargin: 10; top: parent.top; topMargin: 5}
                    color: "gray"; font.pointSize: 8 * point; text: name + " " + surname
                    visible: elDItem.codeVisible
                }

                Text { id: dest
                    anchors { left: personName.left; top: personName.bottom; topMargin: 5}
                    color: "gray"; font.pointSize: 7 * point; text: destination
                    visible: elDItem.codeVisible
                }

                Text { id: reservedHours
                    anchors { left: personName.left; top: dest.bottom; topMargin: 5}
                    color: "gray"; font.pointSize: 7 * point; text: from + " - " + to
                    visible: elDItem.codeVisible
                }

                Rectangle { id: line
                    anchors { left: parent.left; leftMargin: 10; top: reservedHours.bottom; horizontalCenter: parent.horizontalCenter}
                    height: 2
                    width: parent.width
                    color: "lightgray"
                }

           } // Item

        } // Component

        ActionButton { id: nextBtn; width: nextBtn.height * 2.5; height: parent.height * .15
            anchors { right: parent.right; rightMargin: 10; bottom: parent.bottom; }
            visible: isReserveButtonVisible
            buttonText: qsTr("Rezerwuj")
            onActivated: { timePicker.clearTimePicker(); timePicker.setHourIndex(hoursListItem.listofHours.currentIndex); dateChooserStack.push(nextView)}
        }

    } // Rectangle

} // Item
