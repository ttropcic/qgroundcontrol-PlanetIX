import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtPositioning 5.15

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Vehicle
import QGroundControl.Controls
import QGroundControl.FactControls
import QGroundControl.Palette

// Editor for Simple mission items
Rectangle {
    width:  availableWidth
    height: editorColumn.height + (_margin * 2)
    color:  qgcPal.windowShadeDark
    radius: _radius

    property var  _missionController:       _planMasterController.missionController
    property bool _specifiesAltitude:       missionItem.specifiesAltitude
    property real _margin:                  ScreenTools.defaultFontPixelHeight / 2
    property real _altRectMargin:           ScreenTools.defaultFontPixelWidth / 2
    property var  _controllerVehicle:       missionItem.masterController.controllerVehicle
    property int  _globalAltMode:           missionItem.masterController.missionController.globalAltitudeMode
    property bool _globalAltModeIsMixed:    _globalAltMode == QGroundControl.AltitudeModeMixed
    property real _radius:                  ScreenTools.defaultFontPixelWidth / 2

    function updateAltitudeModeText() {
        if (missionItem.altitudeMode === QGroundControl.AltitudeModeRelative) {
            altModeLabel.text = QGroundControl.altitudeModeShortDescription(QGroundControl.AltitudeModeRelative)
        } else if (missionItem.altitudeMode === QGroundControl.AltitudeModeAbsolute) {
            altModeLabel.text = QGroundControl.altitudeModeShortDescription(QGroundControl.AltitudeModeAbsolute)
        } else if (missionItem.altitudeMode === QGroundControl.AltitudeModeCalcAboveTerrain) {
            altModeLabel.text = QGroundControl.altitudeModeShortDescription(QGroundControl.AltitudeModeCalcAboveTerrain)
        } else if (missionItem.altitudeMode === QGroundControl.AltitudeModeTerrainFrame) {
            altModeLabel.text = QGroundControl.altitudeModeShortDescription(QGroundControl.AltitudeModeTerrainFrame)
        } else {
            altModeLabel.text = qsTr("Internal Error")
        }
    }

    function checkLandingPoint() {
        for (let i = 0; i < _missionController.visualItems.count; i++) {
            let item = _missionController.visualItems.get(i);
            if (i > 1) {
                let previousItem = _missionController.visualItems.get(i - 1);
                if ((previousItem.command == 16 // MAV_CMD_NAV_WAYPOINT for regular waypoint
                    || previousItem.command == 3000) // MAV_CMD_DO_VTOL_TRANSITION=3000 for vtol transition point
                    && missionItem.isLandCommand
                    && item.isLandCommand) {
                    if (missionItem.coordinate.latitude == item.coordinate.latitude
                        && missionItem.coordinate.longitude == item.coordinate.longitude) {
                        return previousItem;
                    } else {
                        return null;
                    }
                }
            }
        }
        return null;
    }

    Component.onCompleted: updateAltitudeModeText()

    Connections {
        target:                 missionItem
        onAltitudeModeChanged:  updateAltitudeModeText()
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }
    Component { id: altModeDialogComponent; AltModeDialog { } }

    Column {
        id:                 editorColumn
        anchors.margins:    _margin
        anchors.left:       parent.left
        anchors.right:      parent.right
        anchors.top:        parent.top
        spacing:            _margin

        QGCLabel {
            width:          parent.width
            wrapMode:       Text.WordWrap
            font.pointSize: ScreenTools.smallFontPointSize
            text:           missionItem.rawEdit ?
                                qsTr("Provides advanced access to all commands/parameters. Be very careful!") :
                                missionItem.commandDescription
        }

        ColumnLayout {
            anchors.left:       parent.left
            anchors.right:      parent.right
            spacing:            _margin
            visible:            missionItem.isTakeoffItem && missionItem.wizardMode // Hack special case for takeoff item

            QGCLabel {
                text:               qsTr("Move '%1' %2 to the %3 location. %4")
                .arg(_controllerVehicle.vtol ? qsTr("T") : qsTr("T"))
                .arg(_controllerVehicle.vtol ? qsTr("Transition Direction") : qsTr("Takeoff"))
                .arg(_controllerVehicle.vtol ? qsTr("desired") : qsTr("climbout"))
                .arg(_controllerVehicle.vtol ? (qsTr("Ensure distance from launch to transition direction is far enough to complete transition.")) : "")
                Layout.fillWidth:   true
                wrapMode:           Text.WordWrap
                visible:            !initialClickLabel.visible
            }

            QGCLabel {
                text:               qsTr("Ensure clear of obstacles and into the wind.")
                Layout.fillWidth:   true
                wrapMode:           Text.WordWrap
                visible:            !initialClickLabel.visible
            }

            QGCButton {
                text:               qsTr("Done")
                Layout.fillWidth:   true
                visible:            !initialClickLabel.visible
                onClicked: {
                    missionItem.wizardMode = false
                }
            }

            QGCLabel {
                id:                 initialClickLabel
                text:               missionItem.launchTakeoffAtSameLocation ?
                                        qsTr("Click in map to set planned Takeoff location.") :
                                        qsTr("Click in map to set planned Launch location.")
                Layout.fillWidth:   true
                wrapMode:           Text.WordWrap
                visible:            missionItem.isTakeoffItem && !missionItem.launchCoordinate.isValid
            }
        }

        Column {
            anchors.left:       parent.left
            anchors.right:      parent.right
            spacing:            _altRectMargin
            visible:            !missionItem.wizardMode

            ColumnLayout {
                anchors.left:   parent.left
                anchors.right:  parent.right
                spacing:        0
                visible:        _specifiesAltitude

                QGCLabel {
                    Layout.fillWidth:   true
                    wrapMode:           Text.WordWrap
                    font.pointSize:     ScreenTools.smallFontPointSize
                    text:               qsTr("Altitude below specifies the approximate altitude of the ground. Normally 0 for landing back at original launch location.")
                    visible:            missionItem.isLandCommand
                }

                MouseArea {
                    Layout.preferredWidth:  childrenRect.width
                    Layout.preferredHeight: childrenRect.height

                    onClicked: {
                        if (_globalAltModeIsMixed) {
                            var removeModes = []
                            var updateFunction = function(altMode){ missionItem.altitudeMode = altMode }
                            if (!_controllerVehicle.supportsTerrainFrame) {
                                removeModes.push(QGroundControl.AltitudeModeTerrainFrame)
                            }
                            if (!QGroundControl.corePlugin.options.showMissionAbsoluteAltitude && missionItem.altitudeMode !== QGroundControl.AltitudeModeAbsolute) {
                                removeModes.push(QGroundControl.AltitudeModeAbsolute)
                            }
                            removeModes.push(QGroundControl.AltitudeModeMixed)
                            altModeDialogComponent.createObject(mainWindow, { rgRemoveModes: removeModes, updateAltModeFn: updateFunction }).open()
                        }
                    }

                    RowLayout {
                        spacing: _altRectMargin

                        QGCLabel {
                            Layout.alignment:   Qt.AlignBaseline
                            text:               qsTr("Altitude")
                            font.pointSize:     ScreenTools.smallFontPointSize
                        }
                        QGCLabel {
                            id:                 altModeLabel
                            Layout.alignment:   Qt.AlignBaseline
                            visible:            _globalAltMode !== QGroundControl.AltitudeModeRelative
                        }
                        QGCColoredImage {
                            height:     ScreenTools.defaultFontPixelHeight / 2
                            width:      height
                            source:     "/res/DropArrow.svg"
                            color:      qgcPal.text
                            visible:    _globalAltModeIsMixed
                        }
                    }
                }

                FactTextField {
                    id:                 altField
                    Layout.fillWidth:   true
                    fact:               missionItem.altitude
                }

                QGCLabel {
                    font.pointSize:     ScreenTools.smallFontPointSize
                    text:               qsTr("Actual AMSL alt sent: %1 %2").arg(missionItem.amslAltAboveTerrain.valueString).arg(missionItem.amslAltAboveTerrain.units)
                    visible:            missionItem.altitudeMode === QGroundControl.AltitudeModeCalcAboveTerrain
                }

                QGCLabel {
                    Layout.fillWidth:   true
                    wrapMode:           Text.WordWrap
                    font.pointSize:     ScreenTools.smallFontPointSize
                    text:               qsTr("Distance between last waypoint and Land point (Default: 150 m)")
                    visible:            missionItem.isLandCommand
                }

                QGCTextField {
                    id:                 distanceWaypointLandField
                    Layout.fillWidth:   true
                    text:               "150.00" // Default value
                    unitsLabel:         "m"
                    showUnits:          true
                    numericValuesOnly:  true
                    visible:            missionItem.isLandCommand
                    enabled:            checkLandingPoint() != null ? true : false
                    onEditingFinished: {
                        let previousItem = checkLandingPoint();
                        if (previousItem) {
                            const EARTH_RADIUS = 6371000; // Radius of the Earth in meters

                            function toRadians(degrees) {
                                return degrees * Math.PI / 180;
                            }

                            function haversineDistance(coord1, coord2) {
                                let lat1 = toRadians(coord1.latitude);
                                let lon1 = toRadians(coord1.longitude);
                                let lat2 = toRadians(coord2.latitude);
                                let lon2 = toRadians(coord2.longitude);

                                let dLat = lat2 - lat1;
                                let dLon = lon2 - lon1;

                                let a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                                        Math.cos(lat1) * Math.cos(lat2) *
                                        Math.sin(dLon / 2) * Math.sin(dLon / 2);

                                let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                                return EARTH_RADIUS * c;
                            }

                            let targetDistance = parseFloat(distanceWaypointLandField.text);
                            if (targetDistance < 150) {
                                console.log("Not applying distance between last waypoint and Land point lesser than 150 m.");
                                return;
                            }

                            if (isNaN(targetDistance)) {
                                console.log("Invalid distance value, using default of 150 meters");
                                targetDistance = 150.00; // Fallback to default
                            }

                            let distance = haversineDistance(previousItem.coordinate, missionItem.coordinate);

                            if (distance === targetDistance) {
                                return;
                            }

                            // Adjust point1 to be at 150 meters from point2
                            let scale = targetDistance / distance; // Scale factor
                            let lat1 = previousItem.coordinate.latitude;
                            let lon1 = previousItem.coordinate.longitude;
                            let lat2 = missionItem.coordinate.latitude;
                            let lon2 = missionItem.coordinate.longitude;

                            for (let i = 0; i < _missionController.visualItems.count; i++) {
                                let item = _missionController.visualItems.get(i);
                                if (item.coordinate.latitude == lat1
                                    && item.coordinate.longitude == lon1) {
                                    let newLat = lat2 + (lat1 - lat2) * scale;
                                    let newLon = lon2 + (lon1 - lon2) * scale;
                                    _missionController.visualItems.get(i).coordinate = QtPositioning.coordinate(newLat, newLon);
                                    return;
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                anchors.left:   parent.left
                anchors.right:  parent.right
                spacing:        _margin

                Repeater {
                    model: missionItem.comboboxFacts

                    ColumnLayout {
                        Layout.fillWidth:   true
                        spacing:            0

                        QGCLabel {
                            font.pointSize: ScreenTools.smallFontPointSize
                            text:           object.name
                            visible:        object.name !== ""
                        }

                        FactComboBox {
                            Layout.fillWidth:   true
                            indexModel:         false
                            model:              object.enumStrings
                            fact:               object
                        }
                    }
                }
            }

            GridLayout {
                anchors.left:   parent.left
                anchors.right:  parent.right
                flow:           GridLayout.TopToBottom
                rows:           missionItem.textFieldFacts.count +
                                missionItem.nanFacts.count +
                                (missionItem.speedSection.available ? 1 : 0)
                columns:        2

                Repeater {
                    model: missionItem.textFieldFacts

                    QGCLabel { text: object.name }
                }

                Repeater {
                    model: missionItem.nanFacts

                    QGCCheckBox {
                        text:           object.name
                        checked:        !isNaN(object.rawValue)
                        onClicked:      object.rawValue = checked ? 0 : NaN
                    }
                }

                QGCCheckBox {
                    id:         flightSpeedCheckbox
                    text:       qsTr("Flight Speed")
                    checked:    missionItem.speedSection.specifyFlightSpeed
                    onClicked:  missionItem.speedSection.specifyFlightSpeed = checked
                    visible:    missionItem.speedSection.available
                }


                Repeater {
                    model: missionItem.textFieldFacts

                    FactTextField {
                        showUnits:          true
                        fact:               object
                        Layout.fillWidth:   true
                        enabled:            !object.readOnly
                    }
                }

                Repeater {
                    model: missionItem.nanFacts

                    FactTextField {
                        showUnits:          true
                        fact:               object
                        Layout.fillWidth:   true
                        enabled:            !isNaN(object.rawValue)
                    }
                }

                FactTextField {
                    fact:               missionItem.speedSection.flightSpeed
                    Layout.fillWidth:   true
                    enabled:            flightSpeedCheckbox.checked
                    visible:            missionItem.speedSection.available
                }
            }

            CameraSection {
                checked:    missionItem.cameraSection.settingsSpecified
                visible:    missionItem.cameraSection.available
            }
        }
    }
}
