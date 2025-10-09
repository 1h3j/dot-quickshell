import QtQuick

import "."

Item { id: root
  property string text: ""
  property real scalingFactor: 1
  property color color: CustomColors.primary

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  Text {
    text: root.text
    color: root.color
    font.family: CustomFont.fontFamily
    font.pointSize: CustomFont.ptSize * root.scalingFactor
  }
}
