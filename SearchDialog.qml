import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Dialog {
    id: searchDialog
    modal: true
    width: parent.width * 0.9
    height: parent.height * 0.7
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    padding: 0

    // Signal pour indiquer qu'un pays et un code postal ont été sélectionnés
    signal locationSelected(string country, string zipCode)

    // Style du fond du dialogue
    background: Rectangle {
        radius: 15
        color: "#FFFFFF"
        border.color: "#E0E0E0"
        border.width: 1
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            samples: 16
            color: "#40000000"
        }
    }

    // Propriété pour stocker la liste des pays
    property var countries: [
        "AF - Afghanistan", "AL - Albania", "DZ - Algeria", "AS - American Samoa", "AD - Andorra",
                "AO - Angola", "AI - Anguilla", "AQ - Antarctica", "AR - Argentina", "AM - Armenia",
                "AW - Aruba", "AU - Australia", "AT - Austria", "AZ - Azerbaijan", "BS - Bahamas",
                "BH - Bahrain", "BD - Bangladesh", "BB - Barbados", "BY - Belarus", "BE - Belgium",
                "BZ - Belize", "BJ - Benin", "BM - Bermuda", "BT - Bhutan", "BO - Bolivia",
                "BQ - Bonaire, Sint Eustatius and Saba", "BA - Bosnia and Herzegovina", "BW - Botswana",
                "BV - Bouvet Island", "BR - Brazil", "IO - British Indian Ocean Territory", "BN - Brunei Darussalam",
                "BG - Bulgaria", "BF - Burkina Faso", "BI - Burundi", "CV - Cabo Verde", "KH - Cambodia",
                "CM - Cameroon", "CA - Canada", "KY - Cayman Islands", "CF - Central African Republic",
                "TD - Chad", "CL - Chile", "CN - China", "CX - Christmas Island", "CC - Cocos (Keeling) Islands",
                "CO - Colombia", "KM - Comoros", "CG - Congo", "CD - Congo (Democratic Republic of the)",
                "CK - Cook Islands", "CR - Costa Rica", "HR - Croatia", "CU - Cuba", "CW - Curaçao",
                "CY - Cyprus", "CZ - Czech Republic", "DK - Denmark", "DJ - Djibouti", "DM - Dominica",
                "DO - Dominican Republic", "EC - Ecuador", "EG - Egypt", "SV - El Salvador", "GQ - Equatorial Guinea",
                "ER - Eritrea", "EE - Estonia", "SZ - Eswatini", "ET - Ethiopia", "FK - Falkland Islands (Malvinas)",
                "FO - Faroe Islands", "FJ - Fiji", "FI - Finland", "FR - France", "GF - French Guiana",
                "PF - French Polynesia", "TF - French Southern Territories", "GA - Gabon", "GM - Gambia",
                "GE - Georgia", "DE - Germany", "GH - Ghana", "GI - Gibraltar", "GR - Greece", "GL - Greenland",
                "GD - Grenada", "GP - Guadeloupe", "GU - Guam", "GT - Guatemala", "GG - Guernsey", "GN - Guinea",
                "GW - Guinea-Bissau", "GY - Guyana", "HT - Haiti", "HM - Heard Island and McDonald Islands",
                "VA - Holy See (Vatican City State)", "HN - Honduras", "HK - Hong Kong", "HU - Hungary",
                "IS - Iceland", "IN - India", "ID - Indonesia", "IR - Iran (Islamic Republic of)", "IQ - Iraq",
                "IE - Ireland", "IM - Isle of Man", "IL - Israel", "IT - Italy", "JM - Jamaica", "JP - Japan",
                "JE - Jersey", "JO - Jordan", "KZ - Kazakhstan", "KE - Kenya", "KI - Kiribati", "KP - Korea (Democratic People's Republic of)",
                "KR - Korea (Republic of)", "KW - Kuwait", "KG - Kyrgyzstan", "LA - Lao People's Democratic Republic",
                "LV - Latvia", "LB - Lebanon", "LS - Lesotho", "LR - Liberia", "LY - Libya", "LI - Liechtenstein",
                "LT - Lithuania", "LU - Luxembourg", "MO - Macao", "MG - Madagascar", "MW - Malawi", "MY - Malaysia",
                "MV - Maldives", "ML - Mali", "MT - Malta", "MH - Marshall Islands", "MQ - Martinique", "MR - Mauritania",
                "MU - Mauritius", "YT - Mayotte", "MX - Mexico", "FM - Micronesia (Federated States of)", "MD - Moldova (Republic of)",
                "MC - Monaco", "MN - Mongolia", "ME - Montenegro", "MS - Montserrat", "MA - Morocco", "MZ - Mozambique",
                "MM - Myanmar", "NA - Namibia", "NR - Nauru", "NP - Nepal", "NL - Netherlands", "NC - New Caledonia",
                "NZ - New Zealand", "NI - Nicaragua", "NE - Niger", "NG - Nigeria", "NU - Niue", "NF - Norfolk Island",
                "MK - North Macedonia", "MP - Northern Mariana Islands", "NO - Norway", "OM - Oman", "PK - Pakistan",
                "PW - Palau", "PS - Palestine, State of", "PA - Panama", "PG - Papua New Guinea", "PY - Paraguay",
                "PE - Peru", "PH - Philippines", "PN - Pitcairn", "PL - Poland", "PT - Portugal", "PR - Puerto Rico",
                "QA - Qatar", "RE - Réunion", "RO - Romania", "RU - Russian Federation", "RW - Rwanda", "BL - Saint Barthélemy",
                "SH - Saint Helena, Ascension and Tristan da Cunha", "KN - Saint Kitts and Nevis", "LC - Saint Lucia",
                "MF - Saint Martin (French part)", "PM - Saint Pierre and Miquelon", "VC - Saint Vincent and the Grenadines",
                "WS - Samoa", "SM - San Marino", "ST - Sao Tome and Principe", "SA - Saudi Arabia", "SN - Senegal",
                "RS - Serbia", "SC - Seychelles", "SL - Sierra Leone", "SG - Singapore", "SX - Sint Maarten (Dutch part)",
                "SK - Slovakia", "SI - Slovenia", "SB - Solomon Islands", "SO - Somalia", "ZA - South Africa",
                "GS - South Georgia and the South Sandwich Islands", "SS - South Sudan", "ES - Spain", "LK - Sri Lanka",
                "SD - Sudan", "SR - Suriname", "SJ - Svalbard and Jan Mayen", "SE - Sweden", "CH - Switzerland",
                "SY - Syrian Arab Republic", "TW - Taiwan, Province of China", "TJ - Tajikistan", "TZ - Tanzania, United Republic of",
                "TH - Thailand", "TL - Timor-Leste", "TG - Togo", "TK - Tokelau", "TO - Tonga", "TT - Trinidad and Tobago",
                "TN - Tunisia", "TR - Turkey", "TM - Turkmenistan", "TC - Turks and Caicos Islands", "TV - Tuvalu",
                "UG - Uganda", "UA - Ukraine", "AE - United Arab Emirates", "GB - United Kingdom of Great Britain and Northern Ireland",
                "US - United States of America", "UY - Uruguay", "UZ - Uzbekistan", "VU - Vanuatu", "VE - Venezuela (Bolivarian Republic of)",
                "VN - Viet Nam", "WF - Wallis and Futuna", "EH - Western Sahara", "YE - Yemen", "ZM - Zambia", "ZW - Zimbabwe"
    ]

    // Propriété pour gérer l'état actuel (recherche de pays ou saisie du code postal)
    property bool isCountrySelected: false

    // Fonction pour réinitialiser les champs et l'état
    function resetSearch() {
        searchField.text = ""
        zipCodeField.text = ""
        isCountrySelected = false
        filteredCountries.clear()
    }

    // Réinitialiser les champs lorsque le dialogue est ouvert
    onOpened: {
        resetSearch()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors.margins: 20

        // Champ de recherche pour le pays (visible uniquement si isCountrySelected est false)
        Rectangle {
            id: searchBox
            Layout.fillWidth: true
            height: 50
            radius: 25
            color: "#F5F5F5"
            visible: !isCountrySelected

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 10

                // Icône de recherche
                Image {
                    id: searchIcon
                    source: "qrc:/images/images/baseline_search_black_48.png"
                    width: 24
                    height: 24
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    Layout.leftMargin: 10
                }

                // Champ de texte pour la recherche
                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Enter a country..."
                    font.pixelSize: 16
                    color: "#333333"
                    background: Rectangle {
                        color: "transparent"
                    }
                    onTextChanged: {
                        if (searchField.text === "") {
                            resetSearch() // Réinitialiser la recherche si le champ est vide
                        } else {
                            var searchText = searchField.text.toLowerCase()
                            filteredCountries.clear()
                            for (var i = 0; i < countries.length; i++) {
                                if (countries[i].toLowerCase().includes(searchText)) {
                                    filteredCountries.append({ "name": countries[i] })
                                }
                            }
                        }
                    }
                }
            }
        }

        // Liste des résultats de recherche (visible uniquement si isCountrySelected est false)
        ListView {
            id: countryList
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            clip: true
            model: filteredCountries
            visible: !isCountrySelected
            delegate: ItemDelegate {
                width: parent ? parent.width : 0
                height: 50
                padding: 10

                contentItem: Text {
                    text: model.name
                    font.pixelSize: 16
                    color: "#333333"
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#E0E0E0"
                        anchors.bottom: parent.bottom
                    }
                }

                onClicked: {
                    searchField.text = model.name // Mettre à jour le champ de recherche avec le pays sélectionné
                    isCountrySelected = true // Passer à la deuxième couche
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }

        // Deuxième couche : Saisie du code postal (visible uniquement si isCountrySelected est true)
        ColumnLayout {
            id: zipCodeLayer
            visible: isCountrySelected
            spacing: 10

            // Champ de saisie pour le code postal
            TextField {
                id: zipCodeField
                Layout.fillWidth: true
                placeholderText: "Enter a postal code..."
                font.pixelSize: 16
                color: "#333333"
                background: Rectangle {
                    color: "#F5F5F5"
                    radius: 25
                }
                leftPadding: 20
                rightPadding: 20

                // Validation du code postal (exemple simple)
                onTextChanged: {
                    if (zipCodeField.text.length > 0 && !/^\d+$/.test(zipCodeField.text)) {
                        zipCodeField.background.color = "#FFCCCC" // Rouge en cas d'erreur
                    } else {
                        zipCodeField.background.color = "#F5F5F5" // Revenir à la couleur normale
                    }
                }
            }

            // Bouton "Valider" pour confirmer la sélection
            Rectangle {
                id: okButton
                width: 200
                height: 50
                color: "#6E48AA"
                radius: 25
                border.color: "#4A306D"
                border.width: 2

                Text {
                    text: "Submit"
                    font.pixelSize: 16
                    font.bold: true
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var selectedCountry = searchField.text
                        var selectedZipCode = zipCodeField.text

                        // Validation simple du code postal (exemple)
                        if (selectedZipCode.length === 0 || !/^\d+$/.test(selectedZipCode)) {
                            zipCodeField.background.color = "#FFCCCC" // Rouge en cas d'erreur
                            return
                        }

                        if (selectedCountry && selectedZipCode) {
                            locationSelected(selectedCountry, selectedZipCode) // Émettre le signal
                            resetSearch() // Réinitialiser les champs
                            searchDialog.close() // Fermer le dialogue
                        }
                    }
                }
            }

            // Espaceur pour pousser le bouton "Retour" en bas
            Item {
                Layout.fillHeight: true
            }

            // Bouton "Retour" en bas à gauche
            RowLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom // Aligner en bas à gauche

                Rectangle {
                    id: backButton
                    width: 120
                    height: 40
                    color: "transparent" // Fond transparent pour un look minimaliste
                    radius: 20 // Bords arrondis

                    // Effet d'ombre pour un look moderne
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 2
                        verticalOffset: 2
                        radius: 8
                        samples: 16
                        color: "#40000000" // Ombre légère
                    }

                    // Texte "Retour"
                    Text {
                        text: "Back"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#6E48AA" // Couleur du texte
                        anchors.centerIn: parent
                    }

                    // Animation de survol
                    states: [
                        State {
                            name: "hovered"
                            PropertyChanges { target: backButton; opacity: 0.8 } // Réduire l'opacité au survol
                        }
                    ]

                    transitions: [
                        Transition {
                            from: ""; to: "hovered"
                            NumberAnimation { properties: "opacity"; duration: 200 } // Animation fluide
                        },
                        Transition {
                            from: "hovered"; to: ""
                            NumberAnimation { properties: "opacity"; duration: 200 } // Animation fluide
                        }
                    ]

                    // Zone cliquable
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true // Activer la détection de survol
                        onEntered: backButton.state = "hovered" // Appliquer l'état "hovered"
                        onExited: backButton.state = "" // Revenir à l'état normal
                        onClicked: {
                            isCountrySelected = false // Revenir à la première couche
                        }
                    }
                }
            }
        }
    }

    // Modèle pour les pays filtrés
    ListModel {
        id: filteredCountries
    }
}
