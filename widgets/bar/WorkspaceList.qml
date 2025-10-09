import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "../../modules"

Item { id: root
  RowLayout {
    spacing: 8
    Repeater {
      model: Hyprland.workspaces

      delegate: Rectangle { id: repeatedButton
        required property HyprlandWorkspace modelData
        implicitHeight: 20
        implicitWidth: innerRectangle.implicitWidth

        color: "transparent"

        Rectangle { id: innerRectangle
          implicitHeight: parent.modelData.active || buttonMouseArea.containsMouse ? parent.implicitHeight : 8
          implicitWidth: repeatedButton.modelData.active ? 16 + Math.max(24, childrenRect.width) : (buttonMouseArea.containsMouse ? 16: 8)

          anchors.centerIn: parent

          radius: 10
          color: parent.modelData.active ? CustomColors.primary : CustomColors.secondary

          Behavior on implicitHeight {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
          }

          Behavior on implicitWidth {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
          }

          Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
          }

          CustomText {
            text: repeatedButton.modelData.name
            anchors.centerIn: parent
            color: repeatedButton.modelData.active ? CustomColors.opposite : "transparent"

            Behavior on color {
              ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
          }
        }

        MouseArea { id: buttonMouseArea
          hoverEnabled: true
          anchors.fill: parent
          onReleased: {
            repeatedButton.modelData.activate()
          }
        }
      }
    }
  }
}
