import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import com.example.meteo 1.0
import QtQuick.Window

ApplicationWindow {
    visible: true
    width: 400
    height: 600
    title: "Weather App"
    color: "#6A82FB"


    WeatherData {
        id: weatherApp
        onCityNotFound: {
            cityNotFoundDialog.open(); // Ouvrir le dialogue lorsque la ville n'est pas trouvée
        }
    }

    // Dialogue pour afficher un message lorsque la ville n'est pas trouvée
    Dialog {
        id: cityNotFoundDialog
        modal: true
        width: Math.min(parent.width * 0.8, 400)
        height: 150
        anchors.centerIn: parent
        background: Rectangle {
            color: "#1F1C2C"
            border.color: "#6E48AA"
            border.width: 2
        }

        // Personnaliser le titre
        header: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            Label {
                text: "Error"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                anchors.centerIn: parent
            }
        }

        // Personnaliser les boutons
        footer: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                // Rectangle interactif pour "OK"
                Rectangle {
                    id: okButtonCityNotFound
                    width: 40
                    height: 20
                    color: "#6E48AA"
                    radius: 5

                    Label {
                        text: "OK"
                        color: "white"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            okButtonCityNotFound.scale = 1.1; // Agrandir le rectangle
                        }
                        onExited: {
                            okButtonCityNotFound.scale = 1.0; // Revenir à la taille normale
                        }
                        onClicked: cityNotFoundDialog.close()
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 200 } // Animation fluide
                    }
                }
            }
        }

        // Contenu du dialogue
        Label {
            text: "The city was not found. Please check the postal code"
            color: "white"
            wrapMode: Text.Wrap
            width: parent.width - 40
            anchors.centerIn: parent
        }
    }

    function showLocationSearchDialog() {
        isSearchFromNavbar = true;
        locationSearchDialog.open();
    }
    ListModel {
        id: favoriteCitiesModel
    }

    MenuDrawer {
        id: menuDrawer
        width: Math.min(parent.width, parent.height) / 3 * 2
        height: parent.height
        favoriteCitiesModel: favoriteCitiesModel
    }

    NavBar {
        id: navBar
        width: parent.width
        onSearchClicked: {
            searchDialog.open();
        }
    }

    SearchDialog {
        id: searchDialog
        anchors.centerIn: parent

        onLocationSelected: function(country, zipCode) {
            weatherApp.getWeatherData(zipCode, country.split("-")[0].trim());
        }
    }

    Rectangle {
        anchors {
            top: navBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#6A82FB" }
            GradientStop { position: 1.0; color: "#2C3E50" }
        }

        Column {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 20
            }
            spacing: 20

            Column {
                spacing: 10
                visible: weatherApp.city !== ""
                width: parent.width

                Image {
                    source: weatherApp.weatherLogo
                    width: 100
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: weatherApp.city + ", " + weatherApp.country
                    font.pixelSize: 24
                    color: "white"
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: weatherApp.temperature + " °C"
                    font.pixelSize: 36
                    color: "white"
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: weatherApp.description
                    font.pixelSize: 18
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Grid {
                    columns: 2
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text { text: "Wind speed"; font.pixelSize: 16; color: "white" }
                    Text { text: weatherApp.windSpeed + "Km/h"; font.pixelSize: 16; color: "white" }

                    Text { text: "Precipitation"; font.pixelSize: 16; color: "white" }
                    Text { text: weatherApp.precipitation + "mm"; font.pixelSize: 16; color: "white" }

                    Text { text: "Humidity"; font.pixelSize: 16; color: "white" }
                    Text { text: weatherApp.humidity + "%"; font.pixelSize: 16; color: "white" }
                }
            }
        }
    }

    Dialog {
        id: noCitySelectedDialog
        modal: true
        width: Math.min(parent.width * 0.8, 400)
        height: 150
        anchors.centerIn: parent
        background: Rectangle {
            color: "#1F1C2C"
            border.color: "#6E48AA"
            border.width: 2
        }

        // Personnaliser le titre
        header: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            Label {
                text: "Error"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                anchors.centerIn: parent
            }
        }

        // Personnaliser les boutons
        footer: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                // Rectangle interactif pour "OK"
                Rectangle {
                    id: okButton
                    width: 40
                    height: 20
                    color: "#6E48AA"
                    radius: 5

                    Label {
                        text: "OK"
                        color: "white"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            okButton.scale = 1.1; // Agrandir le rectangle
                        }
                        onExited: {
                            okButton.scale = 1.0; // Revenir à la taille normale
                        }
                        onClicked: noCitySelectedDialog.close()
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 200 } // Animation fluide
                    }
                }
            }
        }

        // Contenu du dialogue
        Label {
            text: "Please select a country before you can add it to your favorites list."
            color: "white"
            wrapMode: Text.Wrap
            width: parent.width - 40
            anchors.centerIn: parent
        }
    }

    Dialog {
        id: cityExistsDialog
        modal: true
        width: Math.min(parent.width * 0.8, 400)
        height: 150
        anchors.centerIn: parent
        background: Rectangle {
            color: "#1F1C2C"
            border.color: "#6E48AA"
            border.width: 2
        }

        // Personnaliser le titre
        header: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            Label {
                text: "Error"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                anchors.centerIn: parent
            }
        }

        // Personnaliser les boutons
        footer: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                // Rectangle interactif pour "OK"
                Rectangle {
                    id: okbutton
                    width: 40
                    height: 20
                    color: "#6E48AA"
                    radius: 5

                    Label {
                        text: "OK"
                        color: "white"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            okbutton.scale = 1.1; // Agrandir le rectangle
                        }
                        onExited: {
                            okbutton.scale = 1.0; // Revenir à la taille normale
                        }
                        onClicked: cityExistsDialog.close()
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 200 } // Animation fluide
                    }
                }
            }
        }

        // Contenu du dialogue
        Label {
            text: "This city already exists in the favorites list."
            color: "white"
            wrapMode: Text.Wrap
            width: parent.width - 40
            anchors.centerIn: parent
        }
    }

    Dialog {
        id: confirmAddCityDialog
        modal: true
        width: Math.min(parent.width * 0.8, 400)
        height: 150
        anchors.centerIn: parent
        background: Rectangle {
            color: "#1F1C2C"
            border.color: "#6E48AA"
            border.width: 2
        }

        // Personnaliser le titre
        header: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            Label {
                text: "Confirmation"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                anchors.centerIn: parent
            }
        }

        // Personnaliser les boutons
        footer: Rectangle {
            color: "#1F1C2C"
            height: 50
            width: parent.width

            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                // Rectangle interactif pour "Oui"
                Rectangle {
                    id: yesButton
                    width: 40
                    height: 20
                    color: "#6E48AA"
                    radius: 5

                    Label {
                        text: "Yes"
                        color: "white"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            yesButton.scale = 1.1; // Agrandir le rectangle
                        }
                        onExited: {
                            yesButton.scale = 1.0; // Revenir à la taille normale
                        }
                        onClicked: {
                            favoriteCitiesModel.append({name: weatherApp.city + ", " + weatherApp.country});
                            confirmAddCityDialog.close();
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 200 } // Animation fluide
                    }
                }

                // Rectangle interactif pour "Non"
                Rectangle {
                    id: noButton
                    width: 40
                    height: 20
                    color: "#6E48AA"
                    radius: 5

                    Label {
                        text: "No"
                        color: "white"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            noButton.scale = 1.1; // Agrandir le rectangle
                        }
                        onExited: {
                            noButton.scale = 1.0; // Revenir à la taille normale
                        }
                        onClicked: confirmAddCityDialog.close()
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 200 } // Animation fluide
                    }
                }
            }
        }

        // Contenu du dialogue
        Label {
            text: "Are you sure you want to add "+weatherApp.city+" to the favorites list?"
            color: "white"
            wrapMode: Text.Wrap
            width: parent.width - 40
            anchors.centerIn: parent
        }
        onAccepted: {
            favoriteCitiesModel.append({name: weatherApp.city + ", " + weatherApp.country});
        }
    }
}
