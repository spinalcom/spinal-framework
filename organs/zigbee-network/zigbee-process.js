// zigbee-process.js

function ZigBeeProcess (network) {
    ZigBeeProcess.super(this, network);

    var _self = this;

    this.spinalZigbee = null;

    this.discovery = function () {

      if (_self.spinalZigbee == null) {
        console.log('There is no Zigbee configuration yet.');
        return;
      }

      _self.spinalZigbee.on('thing_discovered', network.addThing);
      _self.spinalZigbee.on('discovery_started', network.discoveryStarted);
      _self.spinalZigbee.on('discovery_ended', network.discoveryEnded);

      // time it will take to scan the network
      var params = {
        timeout: 30
      };

      _self.spinalZigbee.discover(params).then(function (response) {

        // if it's here then it's a success!
        console.log('Total things:');
        console.log(response.totalThings); // has the total number of physical devices in the network

      }).catch(function (error) {

        // something bad happened
        console.log('Error while discovering devices (wrong network params?)', error);

      });
    }

    this.onchange = function() {

      if (network.discovery_active.has_been_modified() && network.discovery_active.get() == 1)
        _self.discovery();

    }
}

spinalCore.extend(ZigBeeProcess, Process);

module.exports = ZigBeeProcess;
