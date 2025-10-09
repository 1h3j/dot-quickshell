import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../../modules"

Rectangle { id: root
  color: "transparent"

  property int lowPercentage: 30
  property int alertPercentage: 15
  property bool showPercentage: true

  readonly property real nValues: 23

  readonly property bool isAlert: (UPower.displayDevice.percentage * 100 < root.alertPercentage)
  readonly property bool isLow: (UPower.displayDevice.percentage * 100 < root.lowPercentage)
  readonly property bool isCharging: (UPower.displayDevice.state == UPowerDeviceState.Charging)
  readonly property bool isFull: (UPower.displayDevice.state == UPowerDeviceState.FullyCharged)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  RowLayout {
    Item {
      implicitWidth: batteryIcon.imageWidth
      implicitHeight: batteryIcon.imageHeight
      CustomModulatedVectorImage { id: batteryIcon
        anchors.centerIn: parent
        path: `../icons/battery/value/${Math.floor(UPower.displayDevice.percentage * 22)}.svg`
        imageWidth: 32
        imageHeight: 32
        color: !root.isCharging && root.isLow ? "#f44" : (root.isFull ? "#2f4" : CustomColors.primary)
      }

      Loader {
        active: !root.isCharging && root.isAlert
        sourceComponent: batteryAlertOverlay
        anchors.centerIn: parent
      }

      Loader {
        active: root.isCharging
        sourceComponent: batteryChargeOverlay
        anchors.centerIn: parent
      }
      
      Component { id: batteryChargeOverlay
        CustomModulatedVectorImage { 
          path: "../icons/battery/overlays/charging.svg"
          imageWidth: 32
          imageHeight: 32
          color: CustomColors.primary
        }
      }

      Component { id: batteryAlertOverlay
        CustomModulatedVectorImage {
          anchors.centerIn: parent
          path: "../icons/battery/overlays/alert.svg"
          imageWidth: 32
          imageHeight: 32
          color: CustomColors.primary
        }
      }
    }
    CustomText {
      text: `${Math.floor(UPower.displayDevice.percentage * 100)}%`
      scalingFactor: 0.8
    }
  }
}
