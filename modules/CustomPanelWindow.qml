import QtQuick
import Quickshell

import "."

PanelWindow { id: root
  property real padding: 16

  default property alias content: content.data

  color: "transparent"

  implicitWidth: contentWrapper.implicitWidth
  implicitHeight: contentWrapper.implicitHeight

  Rectangle { id: contentWrapper
    color: CustomColors.background
    radius: 16

    implicitWidth: Math.max(64, content.implicitWidth + padding * 2)
    implicitHeight: Math.max(64, content.implicitHeight + padding * 2)

    Rectangle { id: content
      color: "transparent"
      anchors.centerIn: parent

      implicitWidth: childrenRect.width
      implicitHeight: childrenRect.height
    }
  }
}
