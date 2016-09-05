class TreeAppApplication_Sketcher extends TreeAppApplication
    constructor: ->
        super()
        
        @name = 'Sketcher'
        @powered_with    = 'SC'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id
            
        @actions.push
            ico: "img/sketcher_bouton.png"
            siz: 1
            txt: "Web Sketcher"
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                sketcher = @add_item_depending_selected_tree app.data, SketchItem
        

        
            