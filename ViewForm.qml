import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

Item {
    id: viewForm
    signal editClicked(string name)
    onVisibleChanged: if(visible) readDatabase()
    function readDatabase() {
        restaurantModel.clear();
        var db = LocalStorage.openDatabaseSync("Restaurants", "1.0", "My Restaurants", 1000000);

        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                tx.executeSql('CREATE TABLE IF NOT EXISTS Restaurants(name TEXT, image TEXT, adresse TEXT, kategorie TEXT, webseite TEXT, bewertung TEXT, schlagwoerter TEXT, beschreibung TEXT)');

                var rs = null;
                var likeval = "%" + schlagwortEdit.text + "%";
                if(kategorieComboBox.currentText.localeCompare("Alle") === 0 || kategorieComboBox.currentText.localeCompare("") === 0) {
                    if(schlagwortEdit.text.localeCompare("") === 0) {
                        rs = tx.executeSql('SELECT * FROM Restaurants');
                    }
                    else {
                        rs = tx.executeSql('SELECT * FROM Restaurants WHERE schlagwoerter LIKE ?', [likeval]);
                    }
                }
                else {
                    if(schlagwortEdit.text.localeCompare("") === 0) {
                        rs = tx.executeSql('SELECT * FROM Restaurants WHERE kategorie = ?', [kategorieComboBox.currentText]);
                    }
                    else {
                        rs = tx.executeSql('SELECT * FROM Restaurants WHERE kategorie = ? AND schlagwoerter LIKE ?', [kategorieComboBox.currentText, likeval]);
                    }
                }

                for(var i = 0; i < rs.rows.length; i++) {
                    restaurantModel.append({
                        "name":             rs.rows.item(i).name,
                        "image":            rs.rows.item(i).image,
                        "adresse":          rs.rows.item(i).adresse,
                        "kategorie":        rs.rows.item(i).kategorie,
                        "webseite":         rs.rows.item(i).webseite,
                        "bewertung":        rs.rows.item(i).bewertung,
                        "schlagwoerter":    rs.rows.item(i).schlagwoerter,
                        "beschreibung":     rs.rows.item(i).beschreibung
                    });
                }
            }
        )
    }
    ListModel {
        id: restaurantModel
    }
    RowLayout{
        id: topRow
        anchors.leftMargin: 15
        Button {
            id: editButton
            text: qsTr("edit")
            onClicked: {
                viewForm.editClicked(listView.currentItem.name_text);
            }
        }
        Button {
            id: deleteButton
            text: qsTr("delete")
            onClicked: {
                if(!listView.currentItem) {
                    return;
                }

                var db = LocalStorage.openDatabaseSync("Restaurants", "1.0", "My Restaurants", 1000000);

                db.transaction(
                    function(tx) {
                        tx.executeSql('DELETE FROM Restaurants WHERE name = ?', [listView.currentItem.name_text]);
                    }
                )
                readDatabase();
            }
        }
    }

    RowLayout {
        id: kategorieRow
        anchors.leftMargin: 15
        anchors.top: topRow.bottom
        ComboBox {
            id: kategorieComboBox
            model: ["Alle", "Pizza", "Sushi", "Burger"]
            onCurrentIndexChanged: readDatabase()
        }
    }

    RowLayout {
        id: schlagwortRow
        anchors.leftMargin: 15
        anchors.top: kategorieRow.bottom
        Text {
            text: qsTr("Schlagwort")
        }
        TextField {
            id: schlagwortEdit
            placeholderText: qsTr("Schlagwort")
            onTextChanged: readDatabase()
        }
    }

    ListView {
        id: listView
        anchors.top: schlagwortRow.bottom
        anchors.topMargin: 9
        anchors.leftMargin: 15
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        z: -1
        flickableDirection: Flickable.VerticalFlick
        focus: true
        boundsBehavior: Flickable.DragOverBounds
        model: restaurantModel
        delegate: Rectangle {
            property string name_text: name
            id: wrapper
            width: parent.width
            height: childrenRect.height
            color: ListView.isCurrentItem ? "lightsteelblue" : "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index
                }
            }
            Column {
                Image {
                    id: image_item
                    source: image
                }
                Text {
                    text: '<b>Name: </b>' + name
                }
                Text {
                    text: '<b>Adresse: </b>' + adresse
                }
                Text {
                    text: '<b>Kategorie: </b>' + kategorie
                }
                Text {
                    text: '<b>Webseite: </b>' + webseite
                }
                Text {
                    text: '<b>Bewertung: </b>' + bewertung
                }
                Text {
                    text: '<b>Schlagwörter: </b>' + schlagwoerter
                }
                Text {
                    text: '<b>Beschreibung: </b>' + beschreibung
                }
            }
        }
    }
}
