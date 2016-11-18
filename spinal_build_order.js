#!/usr/bin/env node

const fs = require('fs');
const dependencies_filename = '/spinal.json';
const dependencies_output = 'build.order';

var lib_array = [];

function getLibs() {
  var files = fs.readdirSync(".");
  files.forEach(file => {
    var stats = fs.statSync(file);
    if (stats.isDirectory()) {
      var lib;
      try {
        filename = file + dependencies_filename;
        content = fs.readFileSync(filename,'utf8');
        lib = JSON.parse(content);
        lib.name = file;
      } catch(err) {
        lib = {name:file,dependencies:[]};
      }
      lib_array.push(lib);
    }
  });
}

function init_res() {
  var res = [];
  for (var i = 0; i < lib_array.length; i++) {
    var lib = lib_array[i];
    res.push(lib.name);
  }
  return res;
}

function orderDepend(res, file, depend) {
  var change = false;
  var id_depend = res.indexOf(depend);
  if (id_depend == -1) return change;
  var id_res = res.indexOf(file);
  while (id_res < id_depend) {
    // swap res[id_depend] <-> res[id_depend + 1]
    change = true;
    var buff = res[id_depend];
    res[id_depend] = res[id_depend - 1];
    res[id_depend - 1] = buff;
    id_depend--;
  }
  return change;
}

function orderByDepend(res) {
  for (var i = 0; i < lib_array.length; i++) {
    var lib = lib_array[i];
    for (var key in lib.dependencies) {
      if (lib.dependencies.hasOwnProperty(key) && orderDepend(res, lib.name, key) === true) {
        i = -1;
        break;
      }
    }
  }
}

function writeFileOrder(buff) {
  fs.writeFile(dependencies_output, buff, 'utf8', (err) => {
    if (err) {
      console.log("Error writeFile build.order : " + err);
    } else {
      console.log("File " + dependencies_output + " created.");
    }
  });
}

function main() {
  getLibs();
  if (lib_array.length === 0) return;

  var res = init_res();
  orderByDepend(res);
  writeFileOrder(res.join("\n"));
}

main();
