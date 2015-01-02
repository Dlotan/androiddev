import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Rectangle {
    id: addForm
    z: -1
    property alias addButtonText: addButton.text
    property alias name: nameTextField.text
    property alias imageComboBox: imageComboBox
    property alias adresse: adresseTextField.text
    property alias kategorieComboBox: kategorieComboBox
    property alias webseite: webseiteTextField.text
    property alias bewertung: bewertungTextField.text
    property alias schlagwoerter: schlagwoerterTextField.text
    property alias beschreibung: beschreibungTextField.text

    property string oldName: ""
    signal restaurantAdd()

    color: "transparent"
    height: childrenRect.height
    function clear() {
        nameTextField.text = "";
        adresseTextField.text = "";
        webseiteTextField.text = "";
        bewertungTextField.text = "";
        schlagwoerterTextField.text = "";
        beschreibungTextField.text = "";
    }
    Flickable {
        anchors.fill: parent
        contentHeight: parent.height * 1.5
        Text {
            id: headline
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: "<br>ADD</br>"
        }
        Column {
            id: column1
            anchors.top: headline.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.topMargin: 20

            Rectangle {
                id: nameRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Name: "
                    }
                    TextField {
                        id: nameTextField
                        placeholderText: "Name"
                    }
                }
            }

            Rectangle {
                id: imageRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Image: "
                    }
                    ComboBox {
                        id: imageComboBox
                        model: ["copy.png", "cut.png", "new.png", "open.png", "paste.png", "save.png"]
                    }
                }
            }

            Rectangle {
                id: adresseRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Adresse: "
                    }
                    TextField {
                        id: adresseTextField
                        placeholderText: "Adresse"
                    }
                }
            }

            Rectangle {
                id: kategorieRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Kategorie: "
                    }
                    ComboBox {
                        id: kategorieComboBox
                        model: ["Pizza", "Sushi", "Burger"]
                    }
                }
            }

            Rectangle {
                id: webseiteRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Webseite: "
                    }
                    TextField {
                        id: webseiteTextField
                        placeholderText: "Webseite"
                    }
                }
            }

            Rectangle {
                id: bewertungRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Bewertung: "
                    }
                    TextField {
                        id: bewertungTextField
                        placeholderText: "Bewertung"
                    }
                }
            }

            Rectangle {
                id: schlagwoerterRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Name: "
                    }
                    TextField {
                        id: schlagwoerterTextField
                        placeholderText: "Schlagwoerter"
                    }
                }
            }

            Rectangle {
                id: beschreibungRectangle
                height: 50
                width: parent.width
                color: "transparent"
                Row {
                    height: parent.height
                    Text {
                        text: "Beschreibung: "
                    }
                    TextField {
                        id: beschreibungTextField
                        placeholderText: "Beschreibung"
                    }
                }
            }
            Row {
                Button {
                    id: addButton
                    text: "Add"
                    onClicked: {
                        addForm.restaurantAdd();
                    }
                }
                Button {
                    text: "Clear"
                    onClicked: clear()
                }
            }
        }
    }
}

