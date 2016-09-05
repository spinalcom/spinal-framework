class TreeAppModule_Numa extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Floors'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        # add a floor
        @actions.push
            txt: "Add a floor"
            ico: "img/upload_icon_2.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    building = path[ path.length - 1 ]
                    if building instanceof NumaItem 
                        num = building._children.length
                        if num <= 6
                            floor = new FloorItem ("Floor " + num), num
                            building.add_child floor
    #                         app.data.watch_item floor
                            for flat in floor._children
                                app.data.watch_item flat

        # delete a floor
        @actions.push
            txt: "Delete a floor"
            ico: "img/upload_icon_3.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    building = path[ path.length - 1 ]
                    if building instanceof NumaItem 
                        if building._children[0]?
                            last_floor = building._children[ building._children.length - 1 ]
                            app.undo_manager.snapshot()
                            building.rem_child last_floor
                            app.data.delete_from_tree last_floor

        # save on FileSystem
        @actions.push
            txt: "Save building"
            key: [ "" ]
            ico: "img/3floppy-mount-icone-4238-64.png"
            loc: true
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    console.log "saving : ", item
                    alert "Building saved on the Hub!"
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




                               