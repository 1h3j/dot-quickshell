import QtQuick
import Quickshell

import "../../modules"

CustomText {
  text: Qt.formatDateTime(clock.date, "hh:mm A   MMM d")

  SystemClock { id: clock
    precision: SystemClock.second
  }
}
