import QtQuick

Item {
  id: root
  property string taskText: "New Task"
  property bool done: false
  property bool editing: false

  signal textEdited(string newText)
  signal toggled(bool newState)
  signal removed(bool aParameterThatHasNoUseWhatsoeverBecauseQMLIsBeingABitch)

  width: 200
  height: 40

  Row {
    spacing: 8
    anchors.verticalCenter: parent.verticalCenter

    Loader {
      id: removeButtonLoader
      active: true
      sourceComponent: removeButton
    }

    Rectangle {
      width: 20; height: 20
      radius: 6
      color: "transparent"
      border.color: "#fff"
      border.width: 2

      Rectangle {
        id: checkButton
        width: 12; height: 12
        radius: 2
        color: root.done ? "#fff" : "#00ffffff"

        anchors.centerIn: parent

        states: State {
          name: "done"; when: root.done == true
          PropertyChanges {
            checkButton {
              color: "#fff"
            }
          }
        }

        transitions: [
          Transition {
            from: ""; to: "done"; reversible: true

            ColorAnimation {
              duration: 200
            }
          }
        ]
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          root.done = !root.done
          root.toggled(root.done)
        }
      }
    }

    Loader {
      id: textLoader
      active: true
      sourceComponent: root.editing ? editField : labelField
    }
  }

  Component {
    id: removeButton
    Rectangle {
      width: 20; height: 20
      radius: 6
      color: "#E88"

      Text {
        color: "#000"
        anchors.centerIn: parent
        text: "x"
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          root.removed( false )
        }
      }
    }
  }

  Component {
    id: labelField
    Text {
      text: root.taskText
      font.pointSize: 12
      color: root.done ? "#88ffffff" : "#fff"
      font.strikeout: root.done
      
      MouseArea {
        anchors.fill: parent
        onClicked: root.editing = true
      }
    }
  }

  Component {
    id: editField
    TextInput {
      id: input
      text: root.taskText
      selectByMouse: true
      focus: true
      color: "#fff"

      function finishEditing() {
        root.taskText = text
        root.textEdited(root.taskText)
        root.editing = false
      }

      onEditingFinished: finishEditing()
      Keys.onReturnPressed: finishEditing()
    }
  }
}
