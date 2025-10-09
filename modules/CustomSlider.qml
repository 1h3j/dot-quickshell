import QtQuick
import Quickshell.Widgets

import "."

Item { id: root
  property double minValue: 0
  property double maxValue: 100
  property double value: (minValue + maxValue) / 2
  property color sliderColor: CustomColors.primary

  property int explicitLength: 128
  property int containerGirth: 32
  property real radius: 4

  property bool horizontal: true
  property bool expandToParent: true 

  property double sliderLength: mapValue(root.value, root.minValue, root.maxValue, 0, containerLength)
  property double containerLength: ( 
    expandToParent ? (
      horizontal ? ( 
        parent.implicitWidth
      ) : ( parent.implicitHeight )
    ) : ( explicitLength )
  )

  signal pressed( double value )
  signal released( double value )
  signal changed( double value )

  implicitWidth: horizontal ? containerLength : containerGirth
  implicitHeight: horizontal ? containerGirth : containerLength

  default property alias content: labelContent.data

  function mapValue( x, inMin, inMax, outMin, outMax) {
    return ( x - inMin ) * ( outMax - outMin ) / ( inMax - inMin ) + outMin 
  }

  ClippingRectangle {
    id: sliderContainer
    color: CustomColors.quaternary
    radius: root.radius

    implicitWidth: root.implicitWidth
    implicitHeight: root.implicitHeight

    MouseArea {
      anchors.fill: parent
      drag.axis: Drag.XAxis
      drag.minimumX: 0
      drag.maximumX: sliderContainer.implicitWidth 
      drag.minimumY: 0
      drag.maximumY: sliderContainer.implicitWidth

      function updateValue ( mouse ) {
        root.value = root.mapValue(root.horizontal ? mouse.x : mouse.y, 0, root.containerLength, root.minValue, root.maxValue)
        root.value = root.horizontal ? root.value : ( root.minValue + root.maxValue - root.value )
        root.value = Math.min( root.maxValue, root.value )
        root.value = Math.max( root.minValue, root.value )

        root.changed(root.value)
      }

      onPressed: function ( mouse ) { updateValue(mouse); root.pressed( root.value ) }
      onReleased: function ( mouse ) { root.released( root.value ) }
      onPositionChanged: function ( mouse ) { updateValue(mouse) }
    }

    Rectangle {
      id: sliderValue
      color: root.sliderColor
      radius: sliderContainer.radius

      x: root.horizontal ? ( root.sliderLength - root.containerLength ) : 0
      y: root.horizontal ? 0 : ( root.containerLength - root.sliderLength )

      implicitWidth: sliderContainer.implicitWidth
      implicitHeight: sliderContainer.implicitHeight

      Behavior on x { 
        SmoothedAnimation { velocity: 100; duration: 150 }
      }

      Behavior on y { 
        SmoothedAnimation { velocity: 100; duration: 150 }
      }
    }
  }
  
  Rectangle {
    id: labelContent
    color: "transparent"
    anchors.fill: parent
  }
}
