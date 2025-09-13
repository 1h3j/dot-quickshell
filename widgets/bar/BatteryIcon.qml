import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../../modules"

Rectangle { id: root
  color: "transparent"

  property int lowPercentage: 30
  property int alertPercentage: 15
  property bool showPercentage: true

  property bool isAlert: (UPower.displayDevice.percentage * 100 < root.alertPercentage)
  property bool isLow: (UPower.displayDevice.percentage * 100 < root.lowPercentage)
  property bool isCharging: (UPower.displayDevice.state == UPowerDeviceState.Charging)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  RowLayout {
    CustomText {
      text: `${Math.floor(UPower.displayDevice.percentage * 100)}%`
    }

    Item {
      implicitHeight: 32
      implicitWidth: batteryIcon.imageWidth
      CustomModulatedVectorImage { id: batteryIcon
        anchors.centerIn: parent
        path: `../icons/battery-${Math.floor(UPower.displayDevice.percentage * 10)}.svg`
        imageWidth: 40
        imageHeight: 40
        color: !root.isCharging && root.isLow ? "red" : CustomColors.primary
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
          path: "../icons/battery-charge-overlay.svg"
          imageWidth: 40
          imageHeight: 40
          color: CustomColors.primary
        }
      }

      Component { id: batteryAlertOverlay
        CustomModulatedVectorImage {
          anchors.centerIn: parent
          path: "../icons/battery-charge-alert.svg"
          imageWidth: 40
          imageHeight: 40
          color: CustomColors.primary
        }
      }
    }
  }
}
