import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "modules"

PanelWindow { id: root
  color: "transparent"

  exclusionMode: ExclusionMode.Normal

  margins {
    top: -256
  }

  anchors {
    top: true
  }

  Component.onCompleted: {
    startAnim.start()
  }

  implicitWidth: wRoot.implicitWidth
  implicitHeight: wRoot.implicitHeight

  SequentialAnimation { id: startAnim
    PropertyAnimation {
      target: root
      property: "margins.top"
      from: -256
      to: 16
      duration: 300
      easing.type: Easing.OutQuad }
  }

  SequentialAnimation { id: endAnim
    PropertyAnimation {
      target: root
      property: "margins.top"
      to: -256
      from: 16
      duration: 300
      easing.type: Easing.InQuad
    }

    onFinished: {
      Qt.quit()
    }
  }

  CustomContainer {
    id: wRoot

    padding: 32

    property string timenow: ""

    Process {
      running: true
      command: [ "date", "+%I:%M %p"]
      stdout: StdioCollector {
        onStreamFinished: wRoot.timenow = this.text
      }
    }

    ColumnLayout {
      spacing: 16
      CustomText {
        text: "Sleep Alert"
        scalingFactor: 1.61
      }
      CustomText { id: f
      text: `It is currently ${wRoot.timenow} please go to sleep.`
    }

    Row {
      spacing: 8
      CustomButton {
        onClicked: {
          endAnim.start()
        }
        CustomText {
          text: "    Ok    "
        }
      }
      CustomButton {
        flat: true
        onClicked: {
          f.text = "Aight "
        }
        CustomText {
          text: "    No    "
        }
      }
    }
  }
}
}
