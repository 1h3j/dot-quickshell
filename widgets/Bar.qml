import Quickshell

import QtQuick
import QtQuick.Layouts

import "../modules"
import "bar"

Item { id: root
  readonly property int modulesSpacing: 4

  PanelWindow { id: windowRoot  
    color: "transparent"
    implicitHeight: 40
    implicitWidth: 1280

    margins {
      top: 8
    }

    anchors {
      top: true
    }

    Rectangle { id: content
      color: CustomColors.background
      anchors.fill: parent
      radius: 12

      border.color: CustomColors.quaternary
      border.width: 1

      RowLayout {
        anchors.fill: parent
        uniformCellSizes: true

        RowLayout { id: modulesLeft
          Layout.alignment: Qt.AlignLeft
          Layout.leftMargin: 16
          spacing: root.modulesSpacing

          WorkspaceList {
            implicitHeight: childrenRect.height
            implicitWidth: childrenRect.width
            Layout.alignment: Qt.AlignVCenter
          }
        }

        RowLayout { id: modulesCenter
          Layout.alignment: Qt.AlignHCenter
          spacing: root.modulesSpacing
          TextClock {}
        }

        RowLayout { id: modulesRight
          Layout.alignment: Qt.AlignRight
          Layout.rightMargin: 16
          spacing: root.modulesSpacing

          WifiIcon {}
          BatteryIcon {}
        }
      }
    }
  }
}
