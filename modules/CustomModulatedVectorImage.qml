import QtQuick
import QtQuick.Effects
import QtQuick.VectorImage

// import "."

Item {
  id: root
  // color: "transparent"

  required property string path
  property color color
  property real strength: 1.0

  property int imageWidth: 32
  property int imageHeight: 32

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  VectorImage {
    id: vectorImage
    width: root.imageWidth
    height: root.imageHeight
    preferredRendererType: VectorImage.CurveRenderer
    source: root.path
  }

  MultiEffect {
    anchors.fill: vectorImage
    source: vectorImage
    colorization: root.strength
    colorizationColor: root.color
  }
}
