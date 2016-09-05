class TreeAppApplication_Test extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'Test apps'
        @powered_with    = 'SC'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id
        
        
        #unv reader application 3D   
        @actions.push
            ico: "img/test_bouton.png"
            siz: 1
            txt: "test collection item"
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                test = @add_item_depending_selected_tree app.data, ImgDirectorySetItem, (object) =>
                            object.time = app.data.time
                            object._app_data = app.data