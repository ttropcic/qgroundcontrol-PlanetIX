/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml

import QGroundControl.Templates as T
import QGroundControl.Controls
import QGroundControl.ScreenTools
import QGroundControl.Controllers
import QGroundControl.Palette
import QGroundControl.FlightMap
import QGroundControl

T.HorizontalFactValueGrid {
    id:                     _root
    Layout.preferredWidth:  topLayout.width
    Layout.preferredHeight: topLayout.height

    property bool   settingsUnlocked:       false

    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property int    _rowMax:                2
    property real   _rowButtonWidth:        ScreenTools.minTouchPixels
    property real   _rowButtonHeight:       ScreenTools.minTouchPixels / 2
    property real   _editButtonSpacing:     2

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    ColumnLayout {
        id:         topLayout
        spacing:    0

        RowLayout {
            RowLayout {
                id:         labelValueColumnLayout
                spacing:    ScreenTools.defaultFontPixelWidth * 1.25

                Repeater {
                    model: _root.columns

                    GridLayout {
                        rows:           object.count
                        columns:        2
                        rowSpacing:     0
                        columnSpacing:  ScreenTools.defaultFontPixelWidth / 4
                        flow:           GridLayout.TopToBottom

                        Repeater {
                            id:     labelRepeater
                            model:  object

                            InstrumentValueLabel {
                                Layout.fillHeight:      true
                                Layout.alignment:       Qt.AlignRight
                                instrumentValueData:    object
                            }
                        }

                        Repeater {
                            id:     valueRepeater
                            model:  object

                            property real   _index:     index
                            property real   maxWidth:   0
                            property var    lastCheck:  new Date().getTime()

                            function recalcWidth() {
                                var newMaxWidth = 0
                                for (var i=0; i<valueRepeater.count; i++) {
                                    newMaxWidth = Math.max(newMaxWidth, valueRepeater.itemAt(i).contentWidth)
                                }
                                maxWidth = Math.min(maxWidth, newMaxWidth)
                            }

                            InstrumentValueValue {
                                Layout.fillHeight:      true
                                Layout.alignment:       Qt.AlignLeft
                                Layout.preferredWidth:  valueRepeater.maxWidth
                                instrumentValueData:    object

                                property real lastContentWidth

                                Component.onCompleted:  {
                                    valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
                                    lastContentWidth = contentWidth
                                }

                                onContentWidthChanged: {
                                    valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
                                    lastContentWidth = contentWidth
                                    var currentTime = new Date().getTime()
                                    if (currentTime - valueRepeater.lastCheck > 30 * 1000) {
                                        valueRepeater.lastCheck = currentTime
                                        valueRepeater.recalcWidth()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
