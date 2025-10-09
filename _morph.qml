pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Widgets

import "modules"

ShellRoot { id: root
  property bool isShowingA
  CustomPanelWindow {
    ClippingRectangle {
      color: "transparent"
      implicitWidth: root.isShowingA ? 512 : 256
      implicitHeight: root.isShowingA ? 512 : 256

      Behavior on implicitWidth { 
        SmoothedAnimation { velocity: 100; duration: 150 }
      }

      Behavior on implicitHeight { 
        SmoothedAnimation { velocity: 100; duration: 150 }
      }

      Loader {
        active: true
        anchors.centerIn: parent
        sourceComponent: root.isShowingA ? componentA : componentB
      }    
    }

    Component { id: componentA
      Rectangle { id: a
        color: "transparent"
        implicitWidth: 512
        implicitHeight: 512

        CustomButton {
          anchors.centerIn: parent
          CustomText {
            text: "Okay now what"
          }

          onClicked: {
            root.isShowingA = !root.isShowingA
          }
        }
      }
    }

    Component { id: componentB
      Rectangle { id: b
        color: "transparent"
        implicitWidth: 256
        implicitHeight: 256

        CustomButton {
          anchors.centerIn: parent
          CustomText {
            text: "click me"
          }

          onClicked: {
            root.isShowingA = !root.isShowingA
          }
        }
      }
    }
  }
}
