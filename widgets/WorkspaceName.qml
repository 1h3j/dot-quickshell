// TODO: Refactoring : Seperate the window to another widget called SmoothWindow
// TODO: Substitution : Replace volume control to use the SmoothWindow, have a single smooth window that loads between WorkspaceName and VolumeControl

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../modules"

CustomPanelWindow { id: windowRoot
  property bool show: false
  property bool init: false
  property bool animationLeft: true

  exclusionMode: ExclusionMode.Ignore
  aboveWindows: true

  margins {
    bottom: -128
  }

  anchors {
    bottom: true
  }

  function showWindow() {
    decayTimer.restart()

    if ( !init ) {
      init = true
      return
    }

    if ( !windowRoot.show ) {
      windowRoot.show = true 
      startAnim.start()
    }
  }

  Timer { id: decayTimer
    running: true
    interval: 1500
    triggeredOnStart: false

    onTriggered: {
      endAnim.start()
      windowRoot.show = false
    }
  }

  SequentialAnimation { id: startAnim
    PropertyAnimation {
      target: windowRoot
      property: "margins.bottom"
      from: -128
      to: 16
      duration: 350
      easing.type: Easing.OutQuad 
    }
  }

  SequentialAnimation { id: endAnim
    PropertyAnimation {
      target: windowRoot
      property: "margins.bottom"
      to: -128
      from: 16
      duration: 350
      easing.type: Easing.InQuad
    }
  }

  ColumnLayout {
    Item {
      Layout.alignment: Qt.AlignHCenter
      property string text: Hyprland.focusedWorkspace.name
      property HyprlandWorkspace oldWorkspace
      property HyprlandWorkspace currentWorkspace
      implicitWidth: wCurrentText.implicitWidth
      implicitHeight: wOldText.implicitHeight

      onTextChanged: {
        windowRoot.showWindow()
        oldWorkspace = currentWorkspace
        currentWorkspace = Hyprland.focusedWorkspace

        // true = slide left, false = slide right
        windowRoot.animationLeft = currentWorkspace.id <= oldWorkspace.id

        wOldText.text = wCurrentText.text
        wCurrentText.text = text

        scrollAnim.stop()
        scrollAnim.start()
      }

      CustomText {
        id: wCurrentText
        scalingFactor: 2.5921
      }

      CustomText {
        id: wOldText
        scalingFactor: 2.5921
      }

      SequentialAnimation {
        id: scrollAnim
        ParallelAnimation {
          NumberAnimation {
            target: wOldText
            property: "x"
            from: 0
            to: windowRoot.animationLeft
              ? (wCurrentText.implicitWidth + 32 + wOldText.implicitWidth)   // move right if going left
              : -(wCurrentText.implicitWidth + 32 + wOldText.implicitWidth) // move left if going right
            duration: 250
            easing.type: Easing.OutCubic
          }

          NumberAnimation {
            target: wCurrentText
            property: "x"
            from: windowRoot.animationLeft
              ? -(wCurrentText.implicitWidth + 32) // enter from left
              : (wCurrentText.implicitWidth + 32)  // enter from right
            to: 0
            duration: 250
            easing.type: Easing.OutCubic
          }
        }
      }
    }

    CustomText {
      Layout.alignment: Qt.AlignHCenter
      text: "Workspace"
      color: CustomColors.secondary
    }
  }
}
