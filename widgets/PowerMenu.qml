import QtQuick
import QtQuick.Layouts

import Quickshell

import "../modules"

CustomPanelWindow {
  exclusionMode: ExclusionMode.Ignore

  Rectangle {
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    color: "transparent"

    RowLayout {
      CustomButton {
        ColumnLayout {
          CustomModulatedVectorImage {
            path: "../icons/lock.svg"
            color: CustomColors.primary
            imageWidth: 128
            imageHeight: 128
          }
          CustomText {
            Layout.alignment: Qt.AlignHCenter
            scalingFactor: 1.61
            color: CustomColors.secondary
            text: "Lock"
          }
        }
      }
      CustomButton {
        ColumnLayout {
          CustomModulatedVectorImage {
            path: "../icons/sleep.svg"
            color: CustomColors.primary
            imageWidth: 128
            imageHeight: 128
          }
          CustomText {
            Layout.alignment: Qt.AlignHCenter
            scalingFactor: 1.61
            color: CustomColors.secondary
            text: "Sleep"
          }
        }
      }
      CustomButton {
        ColumnLayout {
          CustomModulatedVectorImage {
            path: "../icons/shutdown.svg"
            color: CustomColors.primary
            imageWidth: 128
            imageHeight: 128
          }
          CustomText {
            Layout.alignment: Qt.AlignHCenter
            scalingFactor: 1.61
            color: CustomColors.secondary
            text: "Shutdown"
          }
        }
      }
      CustomButton {
        ColumnLayout {
          CustomModulatedVectorImage {
            path: "../icons/restart.svg"
            color: CustomColors.primary
            imageWidth: 128
            imageHeight: 128
          }
          CustomText {
            Layout.alignment: Qt.AlignHCenter
            scalingFactor: 1.61
            color: CustomColors.secondary
            text: "Restart"
          }
        }
      }
    } 
  }
}
