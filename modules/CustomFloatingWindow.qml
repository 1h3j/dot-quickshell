import QtQuick
import QtQuick.Layouts

import Quickshell
import "."

FloatingWindow {
  id: root

  property double padding: 0
  property bool resizable: false

  color: CustomColors.background

  minimumSize: Qt.size( Math.max(64, contentItem.implicitWidth + padding * 2),
                        Math.max(64, contentItem.implicitHeight + padding * 2))

  maximumSize: resizable 
    ? Qt.size(Number.MAX_VALUE, Number.MAX_VALUE) 
    : Qt.size(Math.max(64, contentItem.implicitWidth + padding * 2),
              Math.max(64, contentItem.implicitHeight + padding * 2))

  default property alias content: contentItem.data

  Rectangle { id: contentItem
    color: "transparent"

    anchors.centerIn: parent
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
  }
}
