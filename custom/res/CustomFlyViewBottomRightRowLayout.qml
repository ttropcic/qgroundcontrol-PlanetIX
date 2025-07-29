import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap
import QGroundControl.Palette
import QGroundControl.ScreenTools

import MAVLink

ColumnLayout {
    id: flightContent
    //width: 700
    height: implicitHeight
    spacing: 0

    visible: _activeVehicle && _activeVehicle.vehicle !== undefined

    Component {
        id: vehicleValues

        QtObject {
            property bool airSpeedInfo:             _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.airSpeed.rawValue) : false
            property bool groundSpeedInfo:          _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.groundSpeed.rawValue) : false
            property bool distanceToHomeInfo:       _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.distanceToHome.rawValue) : false
            property bool altitudeRelativeInfo:     _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.altitudeRelative.rawValue) : false
            property bool altitudeAboveTerrInfo:    _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.altitudeAboveTerr.rawValue) : false
            property bool altitudeAMSLInfo:         _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.altitudeAMSL.rawValue) : false
            property bool throttlePctInfo:          _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.throttlePct.rawValue) : false
            property bool flightTimeInfo:           _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.flightTime.rawValue) : false
            property bool climbRate:                _activeVehicle && _activeVehicle.vehicle ? !isNaN(_activeVehicle.vehicle.climbRate.rawValue) : false

            // GPS information
            property bool gpsSateliteNumberInfo:    _activeVehicle && _activeVehicle.gps ? !isNaN(_activeVehicle.gps.count.rawValue) : false
            property bool gpsFixInfo:               _activeVehicle && _activeVehicle.gps ? !isNaN(_activeVehicle.gps.lock.rawValue) : false

            // Wind information
            property bool windDirectionInfo:        _activeVehicle && _activeVehicle.wind ? !isNaN(_activeVehicle.wind.direction.rawValue) : false
            property bool windSpeedInfo:            _activeVehicle && _activeVehicle.wind ? !isNaN(_activeVehicle.wind.speed.rawValue) : false
        }
    }

    SettingsGroupLayout {
        id: flightSettings
        contentSpacing: 0
        layoutColor: qgcPal.window


        property var flightValuesAvailable
        property real incrementFontIndex: 1.12

        Loader {
            id: flightValuesAvailableLoader
            sourceComponent: vehicleValues
            onLoaded: {
                flightSettings.flightValuesAvailable = flightValuesAvailableLoader.item
            }
        }

        GridLayout {
            id: flightSettingsGrid
            columns: 4

            LabelledLabel {
                label:      qsTr("Air Speed")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.airSpeedInfo
                            ? _activeVehicle.vehicle.airSpeed.value.toFixed(1) + " " + _activeVehicle.vehicle.airSpeed.units
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:   ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor: _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.airSpeedInfo
                            ? (_activeVehicle.vehicle.airSpeed.value > 25 || _activeVehicle.vehicle.airSpeed.value <= 12)
                            ? "red"
                            : (_activeVehicle.vehicle.airSpeed.value > 23 || _activeVehicle.vehicle.airSpeed.value <= 21)
                            ? "#FF8C00" // Dark orange
                            : (_activeVehicle.vehicle.airSpeed.value > 21 && _activeVehicle.vehicle.airSpeed.value <= 23)
                            ? "green"
                            : "red"
                            : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Ground Speed")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.groundSpeedInfo
                            ? _activeVehicle.vehicle.groundSpeed.value.toFixed(2) + " " + _activeVehicle.vehicle.groundSpeed.units
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.groundSpeedInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Distance to Home")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.distanceToHomeInfo
                            ? _activeVehicle.vehicle.distanceToHome.value.toFixed(1) + " " + _activeVehicle.vehicle.distanceToHome.units
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.distanceToHomeInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Relative Altitude")
                labelText:  _activeVehicle && _activeVehicle.vehicle  && flightSettings.flightValuesAvailable.altitudeRelativeInfo
                            ? _activeVehicle.vehicle.altitudeRelative.value.toFixed(1) + " " + _activeVehicle.vehicle.altitudeRelative.units
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.altitudeRelativeInfo
                                    ? (_activeVehicle.vehicle.altitudeRelative.value < 50)
                                        ? "red" : "green"
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Altitude Above Terrain")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.altitudeAboveTerrInfo
                            ? _activeVehicle.vehicle.altitudeAboveTerr.value.toFixed(1) + " " + _activeVehicle.vehicle.altitudeAboveTerr.units
                            : "N/A"
                visible: _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.altitudeAboveTerrInfo
                                    ? (_activeVehicle.vehicle.altitudeRelative.value < 50)
                                        ? "red" : "green"
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Altitude AMSL")
                labelText:  _activeVehicle && _activeVehicle.vehicle  && flightSettings.flightValuesAvailable.altitudeAMSLInfo
                            ? _activeVehicle.vehicle.altitudeAMSL.value.toFixed(1) + " " + _activeVehicle.vehicle.altitudeAMSL.units
                            : "N/A"
                visible: _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.altitudeAMSLInfo
                                    ? (_activeVehicle.vehicle.altitudeRelative.value < 50)
                                        ? "red" : "green"
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label: qsTr("Throttle")
                labelText:  _activeVehicle && _activeVehicle.vehicle  && flightSettings.flightValuesAvailable.throttlePctInfo
                            ? _activeVehicle.vehicle.throttlePct.value.toFixed(1) + " " + _activeVehicle.vehicle.throttlePct.units
                            : "N/A"
                visible: _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.throttlePctInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:              qsTr("Flight Time")
                labelText:          _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.flightTimeInfo
                                    ? _activeVehicle.vehicle.flightTime.valueString
                                    : "N/A"
                visible:            _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.flightTimeInfo
                                    ? (_activeVehicle.vehicle.flightTime.rawValue > (4800)) // 4800 s = 80 min
                                        ? "red" : qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("GPS Satellite Number")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.gpsSateliteNumberInfo
                            ? _activeVehicle.gps.count.value
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.gps && flightSettings.flightValuesAvailable.gpsSateliteNumberInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label: qsTr("GPS Fix")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.gpsFixInfo
                            ? _activeVehicle.gps.lock.enumStringValue
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.gps && flightSettings.flightValuesAvailable.gpsFixInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label: qsTr("Wind Direction")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.windDirectionInfo
                            ? _activeVehicle.wind.direction.value
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.wind && flightSettings.flightValuesAvailable.windDirectionInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Wind Speed")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.windSpeedInfo
                            ? _activeVehicle.wind.speed.value
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.wind && flightSettings.flightValuesAvailable.windSpeedInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }

            LabelledLabel {
                label:      qsTr("Climb Rate")
                labelText:  _activeVehicle && _activeVehicle.vehicle && flightSettings.flightValuesAvailable.climbRateInfo
                            ? _activeVehicle.wind.speed.value
                            : "N/A"
                visible:    _activeVehicle
                //fontSize:           ScreenTools.defaultFontPointSize * flightSettings.incrementFontIndex
                labelColor:         _activeVehicle && _activeVehicle.wind && flightSettings.flightValuesAvailable.climbRateInfo
                                    ? qgcPal.text
                                    : "red"
                fontBoldLabelLabel: true
                fontBoldLabel:      true
                fontPointSize:      9
            }
        }
    }

    Component {
        id: batteryValues

        QtObject {
            property bool currentInfo:          !isNaN(battery.current.rawValue)
            property bool mahConsumedInfo:      !isNaN(battery.mahConsumed.rawValue)
            property bool timeRemainingInfo:    !isNaN(battery.timeRemaining.rawValue)
            property bool percentRemainingInfo: !isNaN(battery.percentRemaining.rawValue)
            property bool chargeStateInfo:      battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED
        }
    }

    Repeater {
        model: _activeVehicle ? _activeVehicle.batteries : 0

        SettingsGroupLayout {
            id: batterySettings
            contentSpacing: 0
            layoutColor: qgcPal.window

            property var batteryValuesAvailable: batteryValuesInfoLoader.item
            property real incrementFontIndex: 1.12 //0.0011 * mainWindow.height

            Loader {
                id:                 batteryValuesInfoLoader
                sourceComponent:    batteryValues

                property var battery: object
            }

            GridLayout {
                id: batterySettingsGrid
                columns: 3

                LabelledLabel {
                    label: qsTr("Charge State")
                    labelText:      _activeVehicle && batteryValuesAvailable.chargeStateInfo
                                    ? object.chargeState.enumStringValue
                                    : "N/A"
                    visible:        _activeVehicle
                    //fontSize:       ScreenTools.defaultFontPointSize * incrementFontIndex
                    labelColor:         _activeVehicle && batteryValuesAvailable.chargeStateInfo
                                    ? qgcPal.text
                                    : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      9
                }

                LabelledLabel {
                    label: qsTr("Remaining")
                    labelText: _activeVehicle && batteryValuesAvailable.timeRemainingInfo
                               ? object.timeRemainingStr.value
                               : "N/A"
                    visible:            _activeVehicle
                    //fontSize:           ScreenTools.defaultFontPointSize * incrementFontIndex
                    labelColor:         _activeVehicle && batteryValuesAvailable.timeRemainingInfo
                                       ? qgcPal.text
                                       : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      9
                }

                LabelledLabel {
                    label:              qsTr("Remaining")
                    labelText:          _activeVehicle && batteryValuesAvailable.percentRemainingInfo
                                        ? object.percentRemaining.valueString + " " + object.percentRemaining.units
                                        : "N/A"
                    visible:            _activeVehicle
                    //fontSize:           ScreenTools.defaultFontPointSize * incrementFontIndex
                    labelColor:         _activeVehicle && batteryValuesAvailable.percentRemainingInfo
                                        ? qgcPal.text
                                        : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      9
                }

                LabelledLabel {
                    label:              qsTr("Voltage")
                    labelText:          _activeVehicle
                                        ? object.voltage.value.toFixed(1) + " " + object.voltage.units
                                        : "N/A"
                    visible:            _activeVehicle
                    //fontSize:           ScreenTools.defaultFontPointSize * incrementFontIndex
                    labelColor:         _activeVehicle
                                        ? (object.voltage.value < 46)
                                            ? "red"
                                            : ((object.voltage.value < 47)
                                            ? "#FF8C00" // Dark orange
                                            : "green")
                                        : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      9
                }

                LabelledLabel {
                    label:              qsTr("Current")
                    labelText:          _activeVehicle && batteryValuesAvailable.currentInfo
                                        ? object.current.value.toFixed(1) + " " + object.current.units
                                        : "N/A"
                    visible:            _activeVehicle
                    //fontSize:           ScreenTools.defaultFontPointSize * incrementFontIndex
                    labelColor:         _activeVehicle && batteryValuesAvailable.currentInfo
                                        ? qgcPal.text
                                        : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      9
                }

                LabelledLabel {
                    label:      qsTr("Consumed")
                    // object.mahConsumed.units is in mAh, and Ah unit is desirable, so divide by 1000
                    labelText:          _activeVehicle && batteryValuesAvailable.mahConsumedInfo
                                        ? (object.mahConsumed.value / 1000).toFixed(1) + " " + "Ah"
                                        : "N/A"
                    visible:            _activeVehicle
                    //fontSize:           ScreenTools.defaultFontPointSize * incrementFontIndex
                    labelColor:         _activeVehicle && batteryValuesAvailable.mahConsumedInfo
                                        ? ((object.mahConsumed.value / 1000) < 15)
                                            ? "green"
                                            : (((object.mahConsumed.value / 1000) < 18)
                                            ? "#FF8C00" // Dark orange
                                            : "red")
                                        : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      9
                }
            }
        }
    }
}



