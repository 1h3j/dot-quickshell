import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import "widgets"
import "modules"

ShellRoot {
  CustomColors {
    id: colors
  }

  FileView {
    id: todoJSON
    path: "/home/aidan/Documents/TODO.json"

    blockLoading: true
    atomicWrites: true
    watchChanges: false

    function saveTasks() {
      var data = { tasks: [] }

      for (var i = 0; i < tasksModel.count; i++) {
        var item = tasksModel.get(i)
        data.tasks.push({
          title: item.text,
          complete: item.complete
        })
      }

      this.setText(JSON.stringify(data))
    }

    function loadTasks() {
      this.waitForJob()
      this.reload()

      var data = JSON.parse(this.text())
      tasksModel.clear()

      for (var i = 0; i < data.tasks.length; i++) {
        tasksModel.append({
          "text": data.tasks[i].title,
          "complete": data.tasks[i].complete
        })
      }
    }

    onFileChanged: loadTasks()
    Component.onCompleted: loadTasks()
  }

  ListModel {
    id: tasksModel
  }


  CustomFloatingWindow {
    padding: 32
    resizable: true
    colors: customColors

    Item {
      anchors.fill: parent
      anchors.margins: 16

      ColumnLayout {
        id: content

        Text {
          text: "TODO LIST"
          color: "#fff"
          font.pointSize: 32
          font.family: "SpaceMono Nerd Font"
          Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
          id: form

          Button {
            text: "Add"
            onClicked: formTextField.finishEditing()
          }

          TextField {
            id: formTextField
            Layout.fillWidth: true

            property var fileRef: todoJSON

            function finishEditing() {
              if (formTextField.text.trim().length == 0) return
              tasksModel.append({
                "text": formTextField.text,
                "complete": false
              })

              formTextField.clear()
              fileRef.saveTasks()
            }

            onEditingFinished: finishEditing()
            Keys.onReturnPressed: finishEditing()
          }
        }

        Repeater {
          model: tasksModel

          TaskWidget {
            taskText: model.text
            done: model.complete

            property var fileRef: todoJSON

            onTextEdited: function ( newText ) {
              tasksModel.set(index, {text: newText, complete: done})
              fileRef.saveTasks()
            }

            onToggled: function ( newState ) {
              tasksModel.set(index, {text: model.text, complete: newState})
              fileRef.saveTasks()
            }

            onRemoved: function ( aParameterThatHasNoUseWhatsoeverBecauseQMLIsBeingABitch ) {
              tasksModel.remove(index)
              fileRef.saveTasks()
            }
          }
        }
      }
    }
  }
}
