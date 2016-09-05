class TreeAppApplication_Annotation extends TreeAppApplication
    constructor: ->
        super()
        
        @name = 'Add a note'
        @powered_with    = 'SC'
            
        @actions.push
            ico: "img/annotation_bouton.png"
            siz: 1
            txt: "Note"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                note = @add_item_depending_selected_tree app.data, AnnotationItem
        

        
            