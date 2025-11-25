pragma ComponentBehavior: Bound

import Quickshell.Widgets
import Quickshell
import QtQuick

import "."

Item {
  id: root

  required property real maxWidth
  property string noneText: "Type Something"
  readonly property string content: textArea.text
  property double radius: 4
  readonly property bool focused: inputArea.activeFocus
  property double padding: 8

  signal escPress
  signal accepted
  signal type (text: string)

  function setContent(newContent) {
    textArea.text = newContent;
    textArea.forceActiveFocus()
  }

  function forceFocus() {
    textArea.forceActiveFocus()
  }

  implicitWidth: inputArea.implicitWidth
  implicitHeight: inputArea.implicitHeight

  Keys.onPressed: (event) => {
    if (event.key === Qt.Key_Escape) {
      escPress()
    }
  }

  ClippingRectangle {
    id: inputArea
    radius: root.radius

    color: "transparent"
    border.width: 1
    border.color: CustomColors.tertiary

    focus: true

    implicitWidth: root.maxWidth + root.padding * 2
    implicitHeight: textArea.implicitHeight + root.padding * 2

    states: [
      State {
        name: "hovered"
        when: mouseArea.containsMouse
        PropertyChanges {
          inputArea {
            color: CustomColors.quaternary
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
      }
    ]

    MouseArea {
      id: mouseArea

      cursorShape: Qt.IBeamCursor
      anchors.fill: parent
      hoverEnabled: true

      onEntered: {
        textArea.forceActiveFocus()
      }
    }

    TextInput {
      id: textArea

      anchors.fill: parent
      anchors.margins: root.padding

      color: CustomColors.primary
      font.pointSize: CustomFont.ptSize * 1.61
      font.family: CustomFont.fontFamily

      onTextChanged: {
        root.type(text)
      }

      onAccepted: {
        root.accepted()
      }

      cursorDelegate: Item {}

      Rectangle {
        id: customCursor

        width: 2
        height: textArea.cursorRectangle.height
        color: CustomColors.primary

        // visible: textArea.activeFocus
        x: textArea.cursorRectangle.x
        y: textArea.cursorRectangle.y

        SequentialAnimation on opacity {
          loops: Animation.Infinite
          NumberAnimation { to: 0.25; duration: 500; easing.type: Easing.InOutQuad }
          NumberAnimation { to: 1; duration: 500; easing.type: Easing.InOutQuad }
        }

        // Update position smoothly
        Behavior on x { 
          SmoothedAnimation { velocity: 150; duration: 150 }
        }
        Behavior on y { 
          SmoothedAnimation { velocity: 150; duration: 150 }
        }
      }
    }

    CustomText {
      id: emptyText
      
      anchors.verticalCenter: textArea.verticalCenter
      anchors.left: textArea.left

      scalingFactor: 1.61

      text: root.noneText

      color: CustomColors.primary
      opacity: 0

      states: [
        State {
          name: "onEmpty"
          when: root.content == ""
          PropertyChanges {
            emptyText {
              opacity: 0.5
            }
          }
        }
      ]

      transitions: [
        Transition {
          from: "*"; to: "*"; reversible: true

          NumberAnimation {
            duration: 200
          }
        }
      ]
    }
  }
}
