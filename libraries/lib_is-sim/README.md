# is-sim

## Description

A modular web administration panel to manage and virtualize environments based on the SpinalCore technology.
Its built-in features include: 
* Structurated data definition and display,
* 3D rendering (WebGL) of pre-defined models,
* Real-time alerts and interaction, 
* Possibility to connect to external softwares and analytics,
* Collaborative work within a SpinalCore architecture,
* Physical devices discovery and communication,
* ...


## Installation

To use the is-sim library easily, you need to install the SpinalCore framework available on <a href='https://github.com/spinalcom/spinal-framework' target='_blank'>Github</a>:
```
git clone https://github.com/spinalcom/spinal-framework.git
```

Change the name of the root folder "spinal-framework" to your system name.

Put your Spinalhub executable (spinalhub_x64_vX.X) downloaded on www.spinalcom.com in the folder.

Install the framework containing the is-sim library:
```
~/path/to/your-system$ make install-issim
```

Run the Spinalhub with its default settings:
```
~/path/to/your-system$ make run
```


## Basic usage

The is-sim interface is divided into two pages : the **desk** and the **lab**.

### Desk
![desk_files](https://cloud.githubusercontent.com/assets/14069348/16004140/571cf824-3160-11e6-8206-1263e00e4a5b.png)
![desk_projects](https://cloud.githubusercontent.com/assets/14069348/16004142/5898e03c-3160-11e6-8a9b-5673669fa4e9.png)

The desk panel allows you to handle files in your SpinalCore database and create projects, which correspond to a independant Lab.


### Lab
![lab](https://cloud.githubusercontent.com/assets/14069348/16004145/5b2eb254-3160-11e6-9af8-69be8e7b9e65.png)
![lab_ex2](https://cloud.githubusercontent.com/assets/14069348/16035930/e526a110-3219-11e6-8418-33b73f4a0ca1.png)

The lab is the working environment of is-sim. It is composed of different panels/toolbars:
  1. **Main toolbar**: Inclusion of your files and applications, animation panel if you have applications that use time parameters.
  2. **Scene panel**: Representation of the whole architecture of the Lab data. Data in is-sim is represented by tree-items displayed here. The **Session** item is the main model of the Lab.
  3. **3D window**: WebGL environment that can display the drawable models present in the Scene panel. The coordinates system is represented in the bottom-left corner and a toolbar to move the camera, hide elements and splice the window is at the top.
  4. **Inspector panel**: Display of the attributes of the tree-item selected in the Scene panel. Attributes are sub-models of a model that allows to have structurated data.
  5. **Contextual toolbar**: Display of buttons actions associated to the selected tree-item in the Scene panel. These actions are analytics or algorithms that can act on the data (the whole session, not only the selected tree-item).



