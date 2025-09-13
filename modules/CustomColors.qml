pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string themePath: Qt.resolvedUrl("../themes/default.json")

  FileView {
    id: themeJSON
    path: root.themePath
    blockLoading: true
    preload: true

    onLoaded: {
      var jsonContent = themeJSON.text()
      root.themeConfig = JSON.parse(jsonContent)
    }
  }

  property var themeConfig: ({
    "selected_theme": "light",
    "light": {
      "primary": "#000000",
      "secondary": "#A0A0A0",
      "tertiary": "#80707070",
      "quaternary": "#40606060",
      "background": "#CCFFFFFF",
    }, 

    "dark": {
      "primary": "#FFFFFF",
      "secondary": "#A0A0A0",
      "tertiary": "#80707070",
      "quaternary": "#40606060",
      "background": "#CC000000",
    }
  })

  readonly property var theme: themeConfig[themeConfig["selected_theme"]]

  readonly property color primary: theme["primary"]
  readonly property color secondary: theme["secondary"]
  readonly property color tertiary: theme["tertiary"]
  readonly property color quaternary: theme["quaternary"]
  readonly property color background: theme["background"]
}
