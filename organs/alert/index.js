var spinalCore = require('spinalcore');

var path = require('path');

var fs = require('fs');
var vm = require('vm');

vm.runInThisContext(fs.readFileSync(path.join(__dirname, 'libraries') + "/lib_is-sim/models.js"));
vm.runInThisContext(fs.readFileSync(path.join(__dirname, 'libraries') + "/lib_smart-building/models.js"));
vm.runInThisContext(fs.readFileSync(path.join(__dirname, 'libraries') + "/lib_zigbee/models.js"));

var conn = spinalCore.connect("http://644:4YCSeYUzsDG8XSrjqXgkDPrdmJ3fQqHs@127.0.0.1:8888/__building__");

var AlertProcess = require('./alert-process');

spinalCore.load(conn, "Network", function (network) {
  spinalCore.load(conn, "Numa", function (numa) {

    var alertProcess = new AlertProcess(numa, network);

  });

});
