class TreeAppModule_add_Flat extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'add flat'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        # add a flat
        @actions.push
            txt: "Add a flat"
            ico: "img/upload_icon_2.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    floor = path[ path.length - 1 ]
                    if floor instanceof FloorItem 
                        num = floor._children.length
                        flat = new FlatItem ("Flat " + num + 1)
                               
                        flat._center.pos[1].set floor._center.pos[1].get() 
                        
                        floor.add_child flat
                        app.data.watch_item flat
                        for flat in flat._children
                            app.data.watch_item flat

        # delete a flat
        @actions.push
            txt: "Delete a flat"
            ico: "img/upload_icon_3.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    floor = path[ path.length - 1 ]
                    if floor instanceof FloorItem 
                        if floor._children[0]?
                            last_flat = floor._children[ floor._children.length - 1 ]
                            app.undo_manager.snapshot()
                            floor.rem_child last_flat
                            app.data.delete_from_tree last_flat





                               