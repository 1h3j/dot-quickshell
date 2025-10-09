import QtQuick
import Quickshell
import Quickshell.Widgets

// import "../modules"

PanelWindow { id: root
  property Component sourceComponent

  color: "transparent"

  width:  Screen.width
  height: Screen.height

  function morph( component: Component ) {
    root.sourceComponent = component
  }

  ClippingRectangle { id: contentWrapper
   implicitWidth: childrenRect.width
   implicitHeight: childrenRect.height

    Behavior on implicitWidth { 
      NumberAnimation {
        duration: 250
        easing.type: Easing.OutQuad
      }
    }

    Behavior on implicitHeight { 
      NumberAnimation {
        duration: 250
        easing.type: Easing.OutQuad
      }
    }

    Loader {
      active: true
      sourceComponent: root.sourceComponent
    }
  }
}
