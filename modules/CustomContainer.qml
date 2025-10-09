import QtQuick
import Quickshell
import Quickshell.Widgets

import "."

Item { id: root
  property real padding: 16
  property bool transparent: false

  default property alias content: content.data

  implicitWidth: content.implicitWidth
  implicitHeight: content.implicitWidth

  ClippingRectangle { id: contentWrapper
    onIwAbsoluteChanged: {
      highestWidth = Math.max(iwAbsolute, highestWidth)
    }

    onIhAbsoluteChanged: {
      highestHeight = Math.max(ihAbsolute, highestHeight)
    }

    color: root.transparent ? "transparent" : CustomColors.background

    border {
      color: CustomColors.tertiary
      width: 1
    }

    radius: 16

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Behavior on implicitWidth { 
      NumberAnimation {
        duration: 250
        easing.type: Easing.OutQuad
      }
    }

    Behavior on implicitHeight { 
      NumberAnimation {
        duration: 250
        easing.type: Easing.OutQuad
      }
    }

    Rectangle { id: content
      color: "transparent"
      anchors.centerIn: parent

      implicitWidth: childrenRect.width
      implicitHeight: childrenRect.height
    }
  }
}
