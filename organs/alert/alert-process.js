// alert-process.js

function AlertProcess (building, network) {
  AlertProcess.super(this, [building, network]);

  var _self = this;

  var lightSensor = _getLightSensor(network);
  var alarm = _getAlarm(network);

  if (lightSensor == null || alarm == null) {
    console.log('No light sensor or alarm detected. Try discovering the network again and re-launch this organ.');
    return;
  }

  this.onchange = function() {
    // flag to react to local changes
    var localChange = false;
    var danger = false;

    // update building model with sensor value
    if (lightSensor.value.has_been_modified()) {
      var lastValue = lightSensor.value.get()[0];
      console.log('Light Sensor value: ' + lastValue);
      if (lastValue > 0 && lastValue < 100) {
        // we simulate that our light sensor is in floor 3, flat 3
        building._children[3]._children[3].fire_detection.set(1);
        localChange = true;
      }
      else
        // we simulate that our light sensor is in floor 3, flat 3
        building._children[3]._children[3].fire_detection.set(0);
    }

    if (localChange || building.has_been_modified()) {
      danger = false;
      var floor_i = building._children.length;
      while (floor_i--) {
        var floor = building._children[floor_i];
        var flat_i = floor._children.length;
        while (flat_i--) {
          var flat = floor._children[flat_i];
            if (flat.fire_detection.get() == 1) {
              danger = true;
              break;
            }
        }
        if (danger)
          break;
      }

      if (danger) {
        // turn on the alarm
        alarm.status.set(1);
      }

    }

  }
}

spinalCore.extend(AlertProcess, Process);

function _getAlarm(network) {

  // pick first alarm
  var router_i = network._children.length;
  while (router_i--) {
    var router = network._children[router_i];
    for (var device in router.devices[0]) {
      // TODO: it would be better to filter by deviceId and not name
      if (router.devices[0].hasOwnProperty(device) && device == 'IASWarningDevice') {
        for (var cluster in router.devices[0][device].clusters[0]) {
          if (router.devices[0][device].clusters[0].hasOwnProperty(cluster) && cluster == 'IASWarningDevice')
            return router.devices[0][device].clusters[0][cluster];
        }
      }
    }
  }
  return null;

}

function _getLightSensor(network) {

  // pick first alarm
  var router_i = network._children.length;
  while (router_i--) {
    var router = network._children[router_i];
    var endDevice_i = router._children.length;
    while (endDevice_i--) {
      var endDevice = router._children[endDevice_i];
      for (var device in endDevice.devices[0]) {
        // TODO: it would be better to filter by deviceId and not name
        if (endDevice.devices[0].hasOwnProperty(device) && device == 'LightSensor') {
          for (var cluster in endDevice.devices[0][device].clusters[0]) {
            if (endDevice.devices[0][device].clusters[0].hasOwnProperty(cluster) && cluster == 'IlluminanceMeasurement')
              return endDevice.devices[0][device].clusters[0][cluster];
          }
        }
      }
    }
  }
  return null;

}

module.exports = AlertProcess;
