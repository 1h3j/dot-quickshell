import QtQuick

import "../../modules"

Rectangle { id: root
  color: "transparent"

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  CustomModulatedVectorImage { id: batteryIcon
    path: "../icons/wifi-3.svg"
    color: CustomColors.primary
  }
}
