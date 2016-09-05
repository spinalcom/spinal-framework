class TreeAppModule_Collection extends TreeAppModule
    constructor: ( @collection_size ) ->
        super()
        
        @mesher = ''
        @name = 'Mesher'

        @add_attr
          _collection_size: collection_size
        
        
        #_ina = ( app ) =>
        #    app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id

        @actions.push
            txt: "add boundary condition"
            ico: "img/add.png"
            fun: ( evt, app ) =>
                #alert "add material"
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    #item._collection_size.set(item._collection_size.get() + 1)
                    @collection_size.set(@collection_size.get() + 1)
                    
        @actions.push
            txt: "remove boundary condition"
            ico: "img/remove.png"
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    #item._collection_size.set(item._collection_size.get() - 1) if item._collection_size.get() > 0  
                    @collection_size.set(@collection_size.get() - 1) if @collection_size.get() > 0    
            
            
        
            