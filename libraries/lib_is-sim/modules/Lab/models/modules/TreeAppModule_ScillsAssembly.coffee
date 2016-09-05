class TreeAppModule_ScillsAssembly extends TreeAppModule
    constructor: ->
        super()
         
        @name = 'Assemblage'
        
        @actions.push
            ico: "img/assembly.png"
            txt: "Assembly"
            siz: 1
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                #@add_ass app.data
                m = @add_item_depending_selected_tree app.data, ScillsAssemblyComputeItem
                
                
                
    add_ass: ( app_data ) =>
        m = @add_item_depending_selected_tree app_data, ScillsAssemblyComputeItem
        app_data.watch_item m
        