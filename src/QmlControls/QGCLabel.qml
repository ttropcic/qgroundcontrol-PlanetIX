import QtQuick
import QtQuick.Controls

import QGroundControl.Palette
import QGroundControl.ScreenTools

Text {
    property real fontSizeQGCLabel: ScreenTools.defaultFontPointSize
    property bool fontBoldQGCLabel: false

    font.pointSize: ScreenTools.defaultFontPointSize
    font.family:    ScreenTools.normalFontFamily
    color:          qgcPal.text
    antialiasing:   true
    font.bold:      fontBoldQGCLabel

    QGCPalette {
        id: qgcPal;
        colorGroupEnabled: enabled
    }
}
