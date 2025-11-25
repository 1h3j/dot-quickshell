pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray

import "../../modules"

import Qt.labs.folderlistmodel

Item { 
  id: root
  implicitWidth: content.implicitWidth + marginH * 2
  implicitHeight: content.implicitHeight + marginV * 2

  FolderListModel {
      id: iconFinder
      // nameFilters: ["*.*"]
      // nameFilters: ["*.png", "*.svg", "*.ico", "*.jpg"]
      // showDirs: false
      showFiles: true
  }

  property QtObject window
  property real padding: 4
  property real marginH: 12
  property real marginV: 0

  Rectangle {
    id: content
    implicitWidth: childrenRect.width + root.padding * 2
    implicitHeight: childrenRect.height + root.padding * 2

    x: root.marginH
    y: root.marginV

    color: CustomColors.tertiary

    border {
      color: CustomColors.secondary
      width: 1
    }

    radius: 6

    Row {
      x: root.padding
      y: root.padding
      id: row
      spacing: 8

      Repeater {
        id: repeater
        model: SystemTray.items

        delegate: Item {
          id: item
          required property SystemTrayItem modelData 
          width: 16
          height: 16

          Component.onCompleted: {
            console.log(image.source)
          }

          Image {
            id: image
            anchors.centerIn: parent
            source: item.modelData.icon
            sourceSize.height: 128
            sourceSize.width: 128
            width: 16
            height: 16
          }

          MouseArea { 
            id: mArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: (mouse) => {
              if (mouse.button === Qt.LeftButton) {
                item.modelData.activate()
              }
              else if (mouse.button === Qt.RightButton) { // If the item has a menu, display it
                if (item.modelData.hasMenu) {
                  var point = item.mapToItem(null, 0, 0);
                  item.modelData.display(root.window, point.x + mouse.x, point.y + mouse.y);
                } else {
                  // Alternate: show a custom QML menu
                  // myCustomMenu.popup()
                }
              }
            }
          }
        }
      }
    }
  }
}
