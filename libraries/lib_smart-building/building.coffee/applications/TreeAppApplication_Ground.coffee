class TreeAppApplication_Ground extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'Ground'
        @powered_with    = 'Spinalcom'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
        
        @actions.push
            ico: "img/ground_button.png"
            siz: 1
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                Ground = @add_item_depending_selected_tree app.data, GroundItem

