class TreeAppModule_ZigBeeNetwork extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'ZigBee Network'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        # save on FileSystem
        @actions.push
            txt: "Save ZigBee Network"
            key: [ "" ]
            ico: "img/3floppy-mount-icone-4238-64.png"
            loc: true
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    console.log "saving : ", item
                    alert "Network saved on the Hub!"
                    if FileSystem? and FileSystem.get_inst()?
                        fs = FileSystem.get_inst()
#                         name = prompt "Item name", item.to_string()
                        dir_save = "/__building__"
                        name_save = prompt "Enter the name of your building:", item._name.get()
                        fs.load_or_make_dir dir_save, ( d, err ) =>
                            building_file = d.detect ( x ) -> x.name.get() == name_save
                            if building_file?
                                d.remove building_file
                            d.add_file name_save, item, model_type: "TreeItem"

        # add a floor
        @actions.push
            txt: "Start Discovery"
            ico: "img/search_icon.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    item = path[ path.length - 1 ]
                    if item instanceof ZigbeeNetwork
                        item.discovery_active.set(true);


                               
