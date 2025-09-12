import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
// import Quickshell.Wayland

import "widgets"
import "modules"

ShellRoot {
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

  CustomPanelWindow {
    padding: 32
    focusable: true
    aboveWindows: false
    // transparent: true

    // anchors: {
    //   top: true
    //   left: true
    // }
    // resizable: true

    Item {
      // anchors.fill: parent
      anchors.margins: 16

      implicitWidth:  childrenRect.width
      implicitHeight: childrenRect.height

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
