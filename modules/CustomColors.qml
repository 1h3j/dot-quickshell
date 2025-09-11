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
      themeConfig = JSON.parse(jsonContent)
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

  property var theme: themeConfig[themeConfig["selected_theme"]]

  property string primary: theme["primary"]
  property string secondary: theme["secondary"]
  property string tertiary: theme["tertiary"]
  property string quaternary: theme["quaternary"]
  property string background: theme["background"]
}
