import QtQuick

import "../../modules"

Rectangle { id: root
  color: "transparent"

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  CustomModulatedVectorImage { id: batteryIcon
    path: "../icons/settings.svg"
    color: CustomColors.primary
  }
}
