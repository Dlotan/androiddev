import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    title: qsTr("Restaurants")
    width: 640
    height: 480
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }
    Rectangle {
        id: topRectangle
        height: topRow.height + 20
        width: parent.width
        color: "darkblue"
        RowLayout {
            id: topRow
            anchors.leftMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 8
            Button {
                id: viewButton
                text: qsTr("view")
                onClicked: showView()
                function showView() {
                    addForm.visible = false;
                    viewForm.visible = true;
                }
            }
            Button {
                id: addButton
                text: qsTr("add")
                onClicked: {
                    addForm.addButtonText = "Add";
                    addForm.oldName = "";
                    addForm.clear();
                    showAdd();
                }
                function showAdd() {
                    viewForm.visible = false;
                    addForm.visible = true;
                }
            }
        }
    }

    ViewForm {
        id: viewForm
        anchors.top: topRectangle.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        visible: true
    }

    AddForm {
        id: addForm
        anchors.top: topRectangle.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        visible: false
    }

    Component.onCompleted: {
        addForm.restaurantAdd.connect(newRestaurant)
        viewForm.editClicked.connect(restaurantEdit)
    }

    function restaurantEdit(restaurantName) {
        var db = LocalStorage.openDatabaseSync("Restaurants", "1.0", "My Restaurants", 1000000);
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('SELECT * FROM Restaurants WHERE name = ?', [restaurantName]);
                for(var i = 0; i < rs.rows.length; i++) {
                    addForm.name =             rs.rows.item(i).name;
                    addForm.imageComboBox.currentIndex = addForm.imageComboBox.find(rs.rows.item(i).image);
                    addForm.adresse =          rs.rows.item(i).adresse;
                    addForm.kategorieComboBox.currentIndex = addForm.kategorieComboBox.find(rs.rows.item(i).kategorie);
                    addForm.webseite =         rs.rows.item(i).webseite;
                    addForm.bewertung =        rs.rows.item(i).bewertung;
                    addForm.schlagwoerter =    rs.rows.item(i).schlagwoerter;
                    addForm.beschreibung =     rs.rows.item(i).beschreibung;
                    break;
                }
                viewButton.showView();
            }
        );
        addForm.oldName = restaurantName;
        addForm.addButtonText = "Edit";
        addButton.showAdd();
    }

    function newRestaurant() {
        var db = LocalStorage.openDatabaseSync("Restaurants", "1.0", "My Restaurants", 1000000);

        db.transaction(
            function(tx) {
                if(addForm.oldName.localeCompare("") !== 0) {
                    tx.executeSql('DELETE FROM Restaurants WHERE name = ?', [addForm.oldName])
                }
                tx.executeSql('INSERT INTO Restaurants VALUES(?, ?, ?, ?, ?, ?, ?, ?)', [addForm.name, addForm.imageComboBox.currentText, addForm.adresse, addForm.kategorieComboBox.currentText, addForm.webseite, addForm.bewertung, addForm.schlagwoerter, addForm.beschreibung]);
                viewButton.showView();
            }
        )
        addForm.oldName = "";
    }
}
