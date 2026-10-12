
import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools
import QGroundControl.Palette

RowLayout {
    id: control

    property string label: ""
    property string labelText: ""
    property color labelColor: qgcPal.text
    property bool fontBoldLabelLabel: false
    property bool fontBoldLabel: false
    property real fontPointSize: ScreenTools.defaultFontPointSize

    spacing: ScreenTools.defaultFontPixelWidth * 0.5

    QGCPalette {
        id: qgcPal
        colorGroupEnabled: true
    }

    QGCLabel {
        id:             _labelLabel
        text:           control.label
        color:          qgcPal.text
        font.bold:      control.fontBoldLabelLabel
        font.pointSize: control.fontPointSize

        Layout.minimumWidth: implicitWidth
        Layout.preferredWidth: implicitWidth
        Layout.fillWidth: false
    }

    QGCLabel {
        id:                 _label
        text:               control.labelText
        color:              control.labelColor
        font.bold:          control.fontBoldLabel
        font.pointSize:     control.fontPointSize

        Layout.fillWidth:   false
    }
}