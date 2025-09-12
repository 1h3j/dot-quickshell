import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../../modules"

Rectangle { id: root
  color: "transparent"

  property int alertPercentage: 30
  property bool showPercentage: true

  function isWarning(): bool {
    return (UPower.displayDevice.percentage * 100 < root.alertPercentage)
  }

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
        color: root.isWarning() ? "red" : CustomColors.primary
      }

      CustomModulatedVectorImage { id: batteryAlertOverlay
        anchors.centerIn: parent
        path: `../icons/battery-charge-alert.svg`
        imageWidth: 40
        imageHeight: 40
        // path: "../icons/battery-5.svg"
        color: CustomColors.primary
        // color: "red"
      }
    }
  }
}
