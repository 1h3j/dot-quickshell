import QtQuick
import QtQuick.Layouts

import "../modules"

Item {
  CustomPanelWindow {
    padding: 32

    ColumnLayout {
      CustomText {
        Layout.alignment: Qt.AlignHCenter
        text: "Clock Organizer"
        scalingFactor: 1.61
      }
    }
  }
}
