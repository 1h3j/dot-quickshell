//@ pragma UseQApplication

import QtQuick
import Quickshell

import "widgets"
import "modules"

ShellRoot { 
  Bar { id: bar }
  // PanelWindow { id: window
  //   color: CustomColors.background 
  //   CustomText {
  //     text: "Hello wrod"
  //   }
  // }

  VolumeControl { id: volumeControl }
  WorkspaceName { }
}
