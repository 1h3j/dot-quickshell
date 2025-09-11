
// TODO: > Change to use pipewire

// TODO: Refactoring and Cleanup

import QtQuick
import QtQuick.Layouts
import QtQuick.VectorImage
import QtQuick.Effects
import Quickshell
import Quickshell.Io

import "../modules"

Item { id: root
  property int decayTime: 1500
  property bool active: false
  property bool muted: false

  IpcHandler {
    target: "volumeControl"

    function activate():void {
      if ( !active ) {
        active = true
        startAnim.start()
      }
    }
  }

  Process { id: updateVolume
    running: false
    command: [ "sh", "-c", "echo \"$(pamixer --get-volume),$(pamixer --get-mute)\"" ]
    stdout: StdioCollector {
      onStreamFinished: {
        var parts = this.text.split(",")
        var value = parts[0] * 1
        var muted = (parts[1] == "true\n")

        if (value != volumeSlider.value || muted != root.muted) {
          decayTimer.restart()
          volumeSlider.value = value
          root.muted = muted
        }
      }
    }
  }

  Process { id: setVolume
    running: false
  }

  Timer { id: decayTimer
    interval: decayTime
    triggeredOnStart: false
    running: root.active
    onTriggered: {
      endAnim.start()
    }
  }

  Timer { id: updateTimer
    interval: 50
    triggeredOnStart: true
    repeat: true
    running: root.active
    onTriggered: {
      updateVolume.running = true
    }
  }

  PanelWindow { id: windowRoot

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    implicitHeight: 64
    implicitWidth: 256

    anchors {
      bottom: true
    }

    margins {
      bottom: -96
    }

    SequentialAnimation { id: startAnim
      PropertyAnimation {
        target: windowRoot
        property: "margins.bottom"
        from: -96
        to: 16
        duration: 300
        easing.type: Easing.OutQuad
      }
    }

    SequentialAnimation { id: endAnim
      PropertyAnimation {
        target: windowRoot
        property: "margins.bottom"
        to: -96
        from: 16
        duration: 300
        easing.type: Easing.InQuad
      }

      onFinished: {
        active = false
      }
    }

    Rectangle { id: content
      radius: 16
      anchors.fill: parent
      color: CustomColors.background
      border.color: CustomColors.quaternary
      border.width: 1

      MouseArea { id: hoverDetect
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: {
          decayTimer.restart()
        }
      }

      Row {
        anchors.centerIn: parent
        spacing: 8
        
        Rectangle {
          color: "transparent"
          radius: 8

          implicitWidth: childrenRect.width
          implicitHeight: childrenRect.height

          CustomModulatedVectorImage {
            path: "../icons/volume-" + (muted ? 0 : Math.min(Math.max(Math.floor(4 * volumeSlider.value / 100 + 0.99), 0), 4)) + ".svg"
            color: muted ? "#f00" : CustomColors.primary
          }

          MouseArea {
            anchors.fill: parent

            onClicked: {
              root.muted = !root.muted
              setVolume.exec({
                command: [ "pamixer", root.muted ? "-m" : "-u"],
                running: true
              })

              decayTimer.restart()
            }
          }
        }

        Rectangle { 
          color: "transparent"
          implicitHeight: childrenRect.height
          implicitWidth: content.width - 72

          Layout.alignment: Qt.AlignHCenter

          CustomSlider { id: volumeSlider
            radius: 8

            CustomText {
              anchors.centerIn: parent
              text: ( root.muted ) ? "Muted" : Math.round(volumeSlider.value) + "%"
              color: CustomColors.secondary
            }

            onPressed: {
              updateTimer.running = false
            }

            onReleased: {
              updateTimer.running = true
            }

            onChanged: function ( value ) {
              setVolume.exec({
                command: [ "pamixer", "--set-volume", `${Math.floor(volumeSlider.value)}`],
                running: true
              })

              if ( root.muted ) {
                root.muted = false
                setVolume.exec({
                  command: [ "pamixer", root.muted ? "-m" : "-u"],
                  running: true
                })
              }

              decayTimer.restart()
            }
          }
        }
      }
    }
  }
}

