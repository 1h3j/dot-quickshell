import QtQuick
import "."


Rectangle {
  id: root

  property double padding: 8
  property double borderWidth: 2
  property bool flat: true

  radius: 4

  default property alias content: buttonContent.data

  signal clicked

  implicitWidth: buttonContent.implicitWidth + root.padding * 2
  implicitHeight: buttonContent.implicitHeight + root.padding * 2

  color: root.flat ? CustomColors.quaternary : "transparent"
  border.width: root.flat ? 0 : root.borderWidth
  border.color: CustomColors.primary

  states: [
    State {
      name: "hovered"
      when: mouseArea.containsMouse && !mouseArea.pressed
      PropertyChanges {
        root {
          color: CustomColors.tertiary
        }
      }
    }, 
    State {
      name: "pressed"
      when: mouseArea.pressed
      PropertyChanges {
        root {
          color: CustomColors.secondary
        }
      }
    }
  ]

  transitions: [
    Transition {
      from: ""; to: "hovered"; reversible: true

      ColorAnimation {
        duration: 200
      }
    },
    Transition {
      from: "pressed"; to: "*"

      ColorAnimation {
        duration: 200
      }
    }
  ]

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true

    onClicked: root.clicked()
  }

  Rectangle {
    id: buttonContent
    anchors.centerIn: parent

    color: "transparent"

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
  }
}
