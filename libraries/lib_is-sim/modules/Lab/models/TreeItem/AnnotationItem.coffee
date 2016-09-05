#
class AnnotationItem extends TreeItem
    constructor: ( name = "Note" ) ->
        super()
         
        @_name.set name
#         @_ico.set "img/note.png"
        @_viewable.set true
            
        @add_attr
            title        : @_name
            posted_by    : USER_EMAIL
            _point       : new PointMesher [ 0, 0, 0 ], 2, 6
            note         : "test"
            link         : "http://www.structure-computation.com"
        
        @add_attr
            radius    : new ConstrainedVal( 4, { min: 0, max: 40 } )
            point     : @_point.point

        @_point.radius = @radius
        
        @note.set "test"
     
    display_suppl_context_actions: ( context_action )  ->
        context_action.push
            txt: "link"
            ico: "img/LinkTo.png"
            fun: ( evt, app ) =>
                myWindow = window.open '',''
                myWindow.document.location.href = @link.get()
                myWindow.focus()
                
        
    accept_child: ( ch ) ->
        false
    
    sub_canvas_items: ->
        [ @_point ]
        
    z_index: ->
        @_point.z_index()
    
    get_model_editor_parameters: ( res ) ->
       res.model_editor[ "note" ] = ModelEditorItem_TextArea
    
    draw: ( info ) ->
        draw_point = info.sel_item[ @model_id ]
        if @_point.length && draw_point
            for pm in @_point
                pm.draw info
                
    get_movable_entities: ( res, info, pos, phase ) ->
        for pm in @_point
            pm.get_movable_entities res, info, pos, phase
            
    on_mouse_down: ( cm, evt, pos, b ) ->
        for pm in @_point
            pm.on_mouse_down cm, evt, pos, b
        return false
            
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        for pm in @_point
            pm.on_mouse_move cm, evt, pos, b, old
        return false