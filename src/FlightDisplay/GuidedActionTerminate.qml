/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QGroundControl

import QGroundControl.FlightDisplay


GuidedToolStripAction {
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle

    text: _guidedController.terminateTitle
    iconSource:    _activeVehicle
                ? (_activeVehicle.terminated
                    ? "/res/TerminateButtonPressed.svg"
                    : "/res/TerminateButtonNotPressed.svg")
                : "/res/TerminateButtonNotPressed.svg"
    visible:       true
    enabled:       _activeVehicle
                ? (_activeVehicle.terminated
                    ? false
                    : true)
                : false
    actionID:      _guidedController.actionTerminate
    // If fullColorIcon is not true, icon is not displayed in color
    fullColorIcon: true
}
