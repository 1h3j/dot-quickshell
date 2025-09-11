import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../../modules"

Item { id: root
  Row {
    spacing: 4
    Repeater {
      model: Hyprland.workspaces
      delegate: Rectangle {
        required property var modelData
        implicitWidth: modelData.active ? 32 : 16
        implicitHeight: 16
        radius: 8

        color: modelData.active ? CustomColors.primary : CustomColors.tertiary

        Behavior on implicitWidth {
          NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        Behavior on color {
          ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        MouseArea {
          anchors.fill: parent
          onReleased: {
            modelData.activate()
          }
        }
      }
    }
  }
}
