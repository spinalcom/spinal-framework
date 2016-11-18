# SpinalCore Framework

A simple, lightweight file to create SpinalCore systems.
This contains a single Makefile that has two goals:
* Create a new system running on SpinalCore technology
* Run and stop the system

## Requirements

* Any GNU/Linux distribution
* An internet connection
* The latest version of the SpinalHub executable, available on www.spinalcom.com

## Installation

Download this repository: 
```bash
git clone https://github.com/spinalcom/spinal-framework.git
```
Change the name of the root folder "spinal-framework" to your system name.

Put your Spinalhub executable (spinalhub_x64_vX.X) downloaded on www.spinalcom.com in the folder.

At this moment, you have two options: installing the basic framework, and installing the same framework and include the is-sim library. For more information about is-sim, see [here](https://github.com/spinalcom/is-sim).

To install the basic framework:
```bash
~/path/to/your-system$ make init
~/path/to/your-system$ make
```
To install the framework containing the is-sim library:
```bash
~/path/to/your-system$ make install-issim
```

### Libraries dependencies
For each libraries an dependencies can be added in the file : "spinal.json".
It's important de specify the dependencies to order to specify the build order.
```
{
  "name": "library name",
  "dependencies": {
    "dependencies name":"version",
    ...
  }
}
```

# exemple for the lib_smart-building:
```
{
  "name": "lib_smart-building",
  "dependencies": {
    "lib_is-sim":"^1.0.0"
  }
}
```

## Run

Once your system is installed, you can directly run the Spinalhub with its default settings:
```bash
~/path/to/your-system$ make run
```
To shutdown the Spinalhub:
```bash
~/path/to/your-system$ make stop
```

