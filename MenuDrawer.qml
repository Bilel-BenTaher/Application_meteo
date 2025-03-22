import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Drawer {
    id: menuDrawer
    width: Math.min(parent.width, parent.height) / 3 * 2
    height: parent.height
    edge: Qt.LeftEdge
    dim: true

    property alias favoriteCitiesModel: favoriteCitiesList.model
    signal citySelected(string city)

    background: Rectangle {
        color: "#1F1C2C"
        opacity: 0.95
        border.color: "#6E48AA"
        border.width: 2

        DropShadow {
            anchors.fill: parent
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8
            samples: 16
            color: "#80000000"
            source: parent
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        Label {
            text: "Menu"
            font.pixelSize: 24
            color: "white"
            font.bold: true
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#6E48AA"
            opacity: 0.5
        }

        Label {
            text: "favorite city"
            font.pixelSize: 18
            color: "white"
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: 10
        }

        ListView {
            id: favoriteCitiesList
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            spacing: 5
            clip: true

            delegate: Rectangle {
                id: cityDelegate
                width: favoriteCitiesList.width
                height: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    Label {
                        id: cityLabel
                        text: model.name
                        font.pixelSize: 16
                        color: "white"
                        elide: Text.ElideRight
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: cityDelegate.color = "#6E48AA"
                            onExited: cityDelegate.color = "transparent"
                            onClicked: {
                                console.log("Selected country: " + model.name);
                                citySelected(model.name);
                                menuDrawer.close();
                            }
                        }
                    }

                    Item {
                        Layout.preferredWidth: 25
                        Layout.preferredHeight: 25
                        Layout.alignment: Qt.AlignRight

                        Image {
                            id: removeIcon
                            source: "qrc:/images/images/baseline_remove_48.png.png"
                            width: parent.width
                            height: parent.height
                            fillMode: Image.PreserveAspectFit
                            clip: true
                            opacity: 0.7

                            Behavior on opacity {
                                NumberAnimation { duration: 200 }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            propagateComposedEvents: false
                            onEntered: removeIcon.opacity = 1.0
                            onExited: removeIcon.opacity = 0.7
                            onClicked: function(mouse) {
                                console.log("Index à supprimer :", index);
                                if (index >= 0 && index < favoriteCitiesModel.count) {
                                    favoriteCitiesModel.remove(index);
                                } else {
                                    console.log("Index invalide :", index);
                                }
                                mouse.accepted = true;
                            }
                        }
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#6E48AA"
            opacity: 0.5
        }

        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "transparent"

            RowLayout {
                anchors.fill: parent

                Item {
                    width: 24
                    height: 24

                    Image {
                        source: "qrc:/images/images/baseline_add_48.png"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        clip: true
                    }
                }

                Label {
                    text: "Add a city"
                    font.pixelSize: 18
                    color: "white"
                    Layout.alignment: Qt.AlignLeft
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#6E48AA"
                onExited: parent.color = "transparent"
                onClicked: {
                    if (weatherApp.city === "" || weatherApp.country === "") {
                        noCitySelectedDialog.open();
                    } else {
                        var cityExists = false;
                        for (var i = 0; i < favoriteCitiesModel.count; i++) { // Utiliser favoriteCitiesModel
                            if (favoriteCitiesModel.get(i).name === weatherApp.city + ", " + weatherApp.country) {
                                cityExists = true;
                                break;
                            }
                        }
                        if (cityExists) {
                            cityExistsDialog.open();
                        } else {
                            confirmAddCityDialog.open();
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
