/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.FactSystem
import QGroundControl.FactControls
import QGroundControl.Controls
import QGroundControl.ScreenTools
import QGroundControl.Palette

SetupPage {
    id:             rebootPage
    pageComponent:  pageComponent
    Component {
        id: pageComponent

        Item {
            width:      Math.max(availableWidth, outerColumn.width)
            height:     outerColumn.height

            FactPanelController {
                id:         controller
            }

            readonly property string hitlParam: "SYS_HITL"

            property real _margins:         ScreenTools.defaultFontPixelHeight
            property real _labelWidth:      ScreenTools.defaultFontPixelWidth  * 30
            property real _editFieldWidth:  ScreenTools.defaultFontPixelWidth  * 20
            property real _imageHeight:     ScreenTools.defaultFontPixelHeight * 3
            property real _imageWidth:      _imageHeight * 2

            property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
            property bool   _showRCToParam:     _activeVehicle.px4Firmware

            ColumnLayout {
                id:         outerColumn
                spacing:    _margins
                anchors.horizontalCenter:   parent.horizontalCenter

                QGCLabel {
                    text:                   qsTr("Reboot Vehicle")
                }

                Rectangle {
                    width:                  mainRow.width  + (_margins * 2)
                    height:                 mainRow.height + (_margins * 2)
                    color:                  qgcPal.windowShade
                    Row {
                        id:                 mainRow
                        spacing:            _margins
                        anchors.centerIn:   parent
                        Item {
                            width:                  _imageWidth
                            height:                 _imageHeight
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                mipmap:             true
                                fillMode:           Image.PreserveAspectFit
                                source:             qgcPal.globalTheme === QGCPalette.Light ? "/qmlimages/reboot_light.svg" : "/qmlimages/reboot.svg"
                                height:             _imageHeight
                                anchors.centerIn:   parent
                            }
                        }
                        GridLayout {
                            columns:                2
                            anchors.verticalCenter: parent.verticalCenter

                            QGCButton {
                                text:           qsTr("Reboot Vehicle")
                                onClicked: { mainWindow.showMessageDialog(qsTr("Reboot Vehicle"),
                                                                            qsTr("Select Ok to reboot vehicle."),
                                                                            Dialog.Cancel | Dialog.Ok,
                                                                            function() { _activeVehicle.rebootVehicle() }) }
                            }
                        }
                    }
                }
            }
        }
    }
}
