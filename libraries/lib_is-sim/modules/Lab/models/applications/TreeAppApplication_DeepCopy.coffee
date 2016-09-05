class TreeAppApplication_DeepCopy extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'Util'
        
        @actions.push
            ico: "img/deepCopy.png"
            txt: "deep_copy"
            siz: 1
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                #@add_ass app.data
                m = @add_item_depending_selected_tree app.data, DeepCopyItem
        