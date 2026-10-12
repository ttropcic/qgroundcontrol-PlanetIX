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
    id:         flightContent
    height:     implicitHeight
    spacing:    0

    visible:    _activeVehicle && _activeVehicle.vehicle !== undefined

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

// In case we want to remove the boarder thats around battery data or general autopilot data we 
// could leave out qgc's SettingsGroupLayout and try out Rectangle
//        Rectangle {
//            id:                                     batterySettings
//            color:                            qgcPal.window
//            implicitWidth: batterySettingsGrid.implicitWidth + ScreenTools.defaultFontPixelWidth * 2
//            implicitHeight: batterySettingsGrid.implicitHeight + ScreenTools.defaultFontPixelHeight
//
//            property var batteryValuesAvailable:    batteryValuesInfoLoader.item


        SettingsGroupLayout {
            id:                                     batterySettings
            contentSpacing:                         0
            layoutColor:                            qgcPal.window
            property var batteryValuesAvailable:    batteryValuesInfoLoader.item

            Loader {
                id:                     batteryValuesInfoLoader
                sourceComponent:        batteryValues
                property var battery:   object
            }

            ColumnLayout {
                id:         batterySettingsGrid

                CustomLabelledLabel {
                    label:              qsTr("Current")
                    labelText:          _activeVehicle && batteryValuesAvailable.currentInfo
                                            ? object.current.value.toFixed(1) + " " + object.current.units
                                            : "N/A"
                    labelColor:         _activeVehicle && batteryValuesAvailable.currentInfo
                                            ? qgcPal.text
                                            : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      ScreenTools.defaultFontPointSize
                }

                CustomLabelledLabel {
                    label:              qsTr("Remaining")
                    labelText:          _activeVehicle && batteryValuesAvailable.timeRemainingInfo
                                            ? object.timeRemainingStr.value
                                            : "N/A"
                    labelColor:         _activeVehicle && batteryValuesAvailable.timeRemainingInfo
                                            ? qgcPal.text
                                            : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      ScreenTools.defaultFontPointSize
                }

                CustomLabelledLabel {
                    label:              qsTr("Consumed")
                    // object.mahConsumed.units is in mAh, and Ah unit is desirable, so divide by 1000
                    labelText:          _activeVehicle && batteryValuesAvailable.mahConsumedInfo
                                            ? (object.mahConsumed.value / 1000).toFixed(1) + " " + "Ah"
                                            : "N/A"
                    labelColor:         _activeVehicle && batteryValuesAvailable.mahConsumedInfo
                                            ? ((object.mahConsumed.value / 1000) < 15)
                                                ? "green"
                                                : (((object.mahConsumed.value / 1000) < 18)
                                                    ? "#FF8C00" // Dark orange
                                                    : "red")
                                            : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      ScreenTools.defaultFontPointSize
                }

                CustomLabelledLabel {
                    label:              qsTr("Voltage")
                    labelText:          _activeVehicle
                                        ? object.voltage.value.toFixed(1) + " " + object.voltage.units
                                        : "N/A"
                    labelColor:         _activeVehicle
                                            ? (object.voltage.value < 46)
                                                ? "red"
                                                : ((object.voltage.value < 47)
                                                    ? "#FF8C00" // Dark orange
                                                    : "green")
                                            : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      ScreenTools.defaultFontPointSize
                }

                CustomLabelledLabel {
                    label:              qsTr("Remaining")
                    labelText:          _activeVehicle && batteryValuesAvailable.percentRemainingInfo
                                            ? object.percentRemaining.valueString + " " + object.percentRemaining.units
                                            : "N/A"
                    labelColor:         _activeVehicle && batteryValuesAvailable.percentRemainingInfo
                                            ? qgcPal.text
                                            : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      ScreenTools.defaultFontPointSize
                }

                CustomLabelledLabel {
                    label:              qsTr("Charge State")
                    labelText:          _activeVehicle && batteryValuesAvailable.chargeStateInfo
                                            ? object.chargeState.enumStringValue
                                            : "N/A"
                    labelColor:         _activeVehicle && batteryValuesAvailable.chargeStateInfo
                                            ? qgcPal.text
                                            : "red"
                    fontBoldLabelLabel: true
                    fontBoldLabel:      true
                    fontPointSize:      ScreenTools.defaultFontPointSize
                }
            }
        }
    }
}



