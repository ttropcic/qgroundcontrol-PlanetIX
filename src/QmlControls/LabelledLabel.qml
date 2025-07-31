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
    spacing:                                ScreenTools.defaultFontPixelWidth * 2

    property alias label:                  _labelLabel.text
    property alias labelText:              _label.text
    property alias labelColor:              _label.color
    property bool fontBoldLabelLabel:       false
    property bool fontBoldLabel:            false
    property int  fontPointSize:            0
    property int fixedLabelWidth:           ScreenTools.defaultFontPixelWidth * 20
    property int fixedValueWidth:           ScreenTools.defaultFontPixelWidth * 12

    QGCLabel {
        id:                     _labelLabel
        Layout.preferredWidth:  fixedLabelWidth
        fontBoldQGCLabel:       fontBoldLabelLabel
        font.pointSize:         fontPointSize
    }

    QGCLabel {
        id:                     _label
        Layout.preferredWidth:  fixedValueWidth
        fontBoldQGCLabel:       fontBoldLabel
        font.pointSize:         fontPointSize
    }
}

