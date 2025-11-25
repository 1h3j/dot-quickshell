pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

import "modules"
import "widgets/bar"

ShellRoot {
  id: root

  CustomPanelWindow {
    exclusionMode: ExclusionMode.Normal

    margins {
      top: 8
    }

    anchors {
      top: true
    }

    Column {
      spacing: 8
      Grid {
        columns: 3
        spacing: 16

        Column {
          spacing: 4
          CustomButton {
            width: 128
            height: 64
            CustomModulatedVectorImage {
              path: "../icons/wifi/values/4.svg"
              color: CustomColors.primary
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
          CustomText {
            text: "Network" 
            anchors.horizontalCenter: parent.horizontalCenter
          }
        }
        Column {
          spacing: 4
          CustomButton {
            width: 128
            height: 64
            CustomModulatedVectorImage {
              path: "../icons/bluetooth.svg"
              color: CustomColors.primary
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
          CustomText {
            text: "Bluetooth" 
            anchors.horizontalCenter: parent.horizontalCenter
          }
        }
        Column {
          spacing: 4
          CustomButton {
            width: 128
            height: 64
            CustomModulatedVectorImage {
              path: "../icons/settings.svg"
              color: CustomColors.primary
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
          CustomText {
            text: "Settings" 
            anchors.horizontalCenter: parent.horizontalCenter
          }
        }
      }

      Rectangle {
        height: 1
        width: parent.width
        color: CustomColors.quaternary
      }

      Item {
        width: parent.width
        height: childrenRect.height

        BatteryIcon { 
          id: batteryIcon
        }
        CustomModulatedVectorImage {
          path: "../icons/gear.svg"
          color: CustomColors.primary
          anchors.right: parent.right
        }
      }
    }
  }
}
