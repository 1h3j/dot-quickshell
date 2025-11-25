pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

import "modules"

ShellRoot {
  id: root

  property string calculationOutput
  // 0 -> None, 1 -> Computation, 2 -> App Runner
  property int mode: 0

  onModeChanged: {
    if (mode == 1) {
      outputStartAnimation.start()
    } else if (mode == 0) {
      outputEndAnimation.start()
    }
  }

  PanelWindow {
    id: inputRoot

    focusable: true
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    implicitWidth: inputContainer.implicitWidth
    implicitHeight: inputContainer.implicitHeight

    anchors {
      top: true
      bottom : true
    }

    Component.onCompleted : {
      inputStartAnimation.start()
      input.forceFocus()
    }

    Process {
      id: infcalc
      command: ["infcalc", ""]
      stdout: StdioCollector {
        onStreamFinished: {
          root.calculationOutput = this.text
          console.log(root.calculationOutput)
        }
      }
    }

    Process {
      id: clipboard
      command: ["wl-copy", ""]
    }

    // Output Animation
    SequentialAnimation {
      id: outputStartAnimation

      PropertyAnimation {
        target: outputContainer
        property: "anchors.topMargin"
        from: -outputContainer.implicitHeight
        to: 16
        duration: 300
        easing.type: Easing.OutQuad 
      }

      onFinished: {
        outputEndAnimation.done = false
      }
    }

    SequentialAnimation {
      id: outputEndAnimation

      property bool done: true

      PropertyAnimation {
        target: outputContainer
        property: "anchors.topMargin"
        to: -outputContainer.implicitHeight
        from: 16
        duration: 300
        easing.type: Easing.InQuad
      }

      onFinished: {
        done = true
      }
    }

    // Input Animation
    SequentialAnimation {
      id: inputStartAnimation

      PropertyAnimation {
        target: inputContainer
        property: "y"
        from: -inputContainer.implicitHeight
        to: 16
        duration: 300
        easing.type: Easing.OutQuad 
      }
    }

    SequentialAnimation {
      id: inputEndAnimation

      PropertyAnimation {
        target: inputContainer
        property: "y"
        to: -inputContainer.implicitHeight
        from: 16
        duration: 300
        easing.type: Easing.InQuad
      }

      onStarted: {
        if (!outputEndAnimation.done) outputEndAnimation.start()
      }

      onFinished: {
        Qt.quit()
      }
    }

    CustomContainer {
      id: outputContainer

      anchors.top: inputContainer.bottom
      anchors.topMargin: -outputContainer.implicitHeight

      Column {
        CustomText {
          scalingFactor: 1.61
          text: "=" + root.calculationOutput
        }
        CustomText {
          text: "Press [ENTER] to copy to clipboard"
          color: CustomColors.tertiary
        }
      }
    }

    CustomContainer {
      id: inputContainer

      Column {
        spacing: 8

        CustomTextInput {
          id: input
          padding: 16
          maxWidth: 512

          onEscPress: {
            inputEndAnimation.start()
          }

          onType: (text) => {
            if (text !== "" && text.startsWith("=")) {
              root.mode = 1
              infcalc.command[1] = text.substring(1)
              infcalc.running = true;
            } else {
              root.mode = 0
            }
          }

          onAccepted: {
            inputEndAnimation.start()
            clipboard.command[1] = root.calculationOutput;
            clipboard.running = true;
          }
        }
      }
    }
  }
}
