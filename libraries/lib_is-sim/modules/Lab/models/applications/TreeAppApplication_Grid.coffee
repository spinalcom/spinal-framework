class TreeAppApplication_Grid extends TreeAppApplication
    constructor: ->
        super()
        
        @name = 'Add a grid'
        @powered_with    = 'SC'
            
        @actions.push
            ico: "img/grid_bouton.png"
            siz: 1
            txt: "Grid"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                grid = @add_item_depending_selected_tree app.data, GridItem
        

        
            