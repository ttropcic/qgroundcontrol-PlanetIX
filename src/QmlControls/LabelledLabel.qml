/****************************************************************************
 *
 * (c) 2009-2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts

import QGroundControl.Controls
import QGroundControl.ScreenTools

RowLayout {
    id: r1
    property alias label:                  _labelLabel.text
    property alias labelText:              _label.text
    property real  labelPreferredWidth:    -1

    property alias labelColor:              _label.color
    property real fontSize:                 ScreenTools.defaultFontPointSize
    property bool fontBoldLabelLabel:       false
    property bool fontBoldLabel:            false
    property int  fontPointSize:            0
    // property color backgroundColor:         "transparent"
    // property real backgroundOpacity:                   1
    property int fixedLabelWidth: ScreenTools.defaultFontPixelWidth * 20
    property int fixedValueWidth: ScreenTools.defaultFontPixelWidth * 12

    spacing: ScreenTools.defaultFontPixelWidth * 2

    QGCLabel {
        id:                 _labelLabel
        //Layout.fillWidth:   true
        Layout.preferredWidth: fixedLabelWidth
        fontSizeQGCLabel:   fontSize
        fontBoldQGCLabel:   fontBoldLabelLabel
        font.pointSize:     fontPointSize

        // Rectangle {
        //     id: _labelLabelBackground
        //     z: -1
        //     width: r1.width
        //     height: _labelLabel.height
        //     color: backgroundColor
        //     opacity: backgroundOpacity
        // }
    }

    QGCLabel {
        id:                     _label
        //Layout.preferredWidth:  labelPreferredWidth
        Layout.preferredWidth: fixedValueWidth
        fontSizeQGCLabel:       fontSize
        fontBoldQGCLabel:       fontBoldLabel
        font.pointSize:         fontPointSize

        // Rectangle {
        //     id: _labelBackground
        //     z: -1
        //     width: _label.width
        //     height: _label.height
        //     color: backgroundColor
        //     opacity: backgroundOpacity
        // }
    }
}

