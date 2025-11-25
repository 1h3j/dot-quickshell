import QtQuick
import Quickshell.Widgets
import Quickshell.Services.UPower

import "../../modules"

Rectangle { id: root
  color: "transparent"

  property int lowPercentage: 30
  property int alertPercentage: 15

  readonly property bool isAlert: (UPower.displayDevice.percentage * 100 < root.alertPercentage)
  readonly property bool isLow: (UPower.displayDevice.percentage * 100 < root.lowPercentage)
  readonly property bool isCharging: (UPower.displayDevice.state == UPowerDeviceState.Charging)
  readonly property bool isFull: (UPower.displayDevice.state == UPowerDeviceState.FullyCharged)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  Item {
    implicitWidth: batteryOutline.imageWidth
    implicitHeight: batteryOutline.imageHeight

    CustomModulatedVectorImage { id: batteryOutline
      path: "../icons/battery-new/outline.svg"

      imageWidth: 48
      imageHeight: 32
      color: "#a0a0a0"
    }

    Item {
      anchors.centerIn: batteryOutline

      implicitWidth: batteryFill.imageWidth
      implicitHeight: batteryFill.imageHeight

      ClippingRectangle {
        color: "transparent"

        implicitWidth: batteryFill.imageWidth * UPower.displayDevice.percentage
        implicitHeight: batteryFill.imageHeight

        CustomModulatedVectorImage { id: batteryFill
          path: "../icons/battery-new/bar.svg"

          imageWidth: 34
          imageHeight: 12

          color: (root.isLow && !root.isCharging) ? "#f00" : "#fff"
        }
      }
    }

    Loader {
      sourceComponent: batteryChargingComponent
      active: UPower.displayDevice.state == UPowerDeviceState.Charging
    }

    Loader {
      sourceComponent: batteryPercentage
      active: UPower.displayDevice.state != UPowerDeviceState.Charging
      anchors.centerIn: batteryOutline
    }

    Component { id: batteryPercentage
      CustomText {
        text: Math.round(UPower.displayDevice.percentage * 100)
        color: "#808080"
      }
    }

    Component { id: batteryChargingComponent
      CustomModulatedVectorImage { id: batteryChargingOverlay
        path: "../icons/battery-new/charging.svg"

        imageWidth: 48
        imageHeight: 32
        color: "#ffffff"
      }
    }
  }
}
