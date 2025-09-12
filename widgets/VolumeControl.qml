
// TODO: Refactoring and Cleanup

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.VectorImage

import Quickshell
import Quickshell.Services.Pipewire

import "../modules"

Item { id: root
  property int decayTime: 1500
  property bool show: false
  property bool init: false

  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink ] }

  Connections {
    target: Pipewire.defaultAudioSink?.audio

    function showWindow() {
      if ( !root.init ) {
        root.init = true
        return
      }

      decayTimer.restart()
      if ( !root.show ) {
        root.show = true
        startAnim.start()
      }
    }

    function onVolumeChanged() {
      volumeSlider.value = Pipewire.defaultAudioSink.audio.volume * 100
      showWindow()
    }

    function onMutedChanged() {
      showWindow()
    }
  }

  Timer { id: decayTimer
    interval: decayTime
    triggeredOnStart: false
    onTriggered: {
      endAnim.start()
    }
  }

  PanelWindow { id: windowRoot
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    implicitHeight: 64
    implicitWidth: 318

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
        root.show = false
      }
    }

    Rectangle { id: content
      radius: 16
      anchors.fill: parent
      color: CustomColors.background
      border.color: CustomColors.quaternary
      border.width: 1

      states: [
        State { name: "muted"
          when: Pipewire.defaultAudioSink.audio.muted
          PropertyChanges {
            volumeSlider {
              sliderColor: CustomColors.quaternary
            }
            volumeIcon {
              color: "red"
            }
          }
        }
      ]

      transitions: [
        Transition {
          from: "*"; to: "*"; reversible: true

          ColorAnimation {
            duration: 200
          }
        }
      ]

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

          implicitWidth: childrenRect.width
          implicitHeight: childrenRect.height

          CustomModulatedVectorImage { id: volumeIcon
            path: "../icons/volume-" + (Pipewire.defaultAudioSink.audio.muted ? 0 : Math.min(Math.max(Math.floor(4 * volumeSlider.value / 100 + 0.99), 0), 4)) + ".svg"
            color: CustomColors.primary
          }

          MouseArea {
            anchors.fill: parent

            onClicked: {
              Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
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
            sliderColor: Pipewire.defaultAudioSink.audio.muted ? CustomColors.quaternary : CustomColors.primary

            CustomText {
              anchors.centerIn: parent
              text: ( Pipewire.defaultAudioSink.audio.muted ) ? "Muted" : Math.round(volumeSlider.value) + "%"
              color: CustomColors.secondary
            }

            onChanged: function ( value ) {
              Pipewire.defaultAudioSink.audio.volume = value / 100.0
              decayTimer.restart()
            }
          }
        }
      }
    }
  }
}
