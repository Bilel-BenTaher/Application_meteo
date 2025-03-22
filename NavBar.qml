import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: navbar
    width: parent.width
    height: 60
    color: "transparent"
    opacity: 0.9
    border.color: "#1F1C2C"
    border.width: 1
    radius: 5

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#6A82FB" }
        GradientStop { position: 1.0; color: "#2C3E50" }
    }

    signal searchClicked()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Menu hamburger à gauche
        Rectangle {
            width: 32
            height: 32
            color: "transparent"
            Layout.alignment: Qt.AlignLeft

            Image {
                id: menuIcon
                source: "qrc:/images/images/baseline_menu_white_48.png" // Chemin de l'icône du menu
                width: 24
                height: 24
                anchors.centerIn: parent

                Behavior on scale {
                    NumberAnimation { duration: 200 }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: menuIcon.scale = 1.2
                onExited: menuIcon.scale = 1.0
                onClicked: menuDrawer.open() // Ouvre le tiroir du menu
            }
        }

        // Nom de l'application au centre
        Label {
            text: "Weather App"
            font.pixelSize: 20
            color: "white"
            font.bold: true
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            Behavior on scale {
                NumberAnimation { duration: 200 }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.scale = 1.1
                onExited: parent.scale = 1.0
            }
        }

        // Icône de recherche à droite
        Rectangle {
            width: 32
            height: 32
            color: "transparent"
            Layout.alignment: Qt.AlignRight

            Image {
                id: searchIcon
                source: "qrc:/images/images/baseline_search_white_48.png" // Chemin de l'icône de recherche
                width: 24
                height: 24
                anchors.centerIn: parent

                Behavior on scale {
                    NumberAnimation { duration: 200 }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: searchIcon.scale = 1.2
                onExited: searchIcon.scale = 1.0
                onClicked: {
                    console.log("Recherche cliquée")
                    searchClicked() // Émet le signal searchClicked
                }
            }
        }
    }
}
