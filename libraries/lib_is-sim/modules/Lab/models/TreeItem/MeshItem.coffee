#
class MeshItem extends TreeItem
    constructor: ( legend = undefined ) ->
        super()
        
        # default values
        @_name.set "Mesh"
        @_ico.set "img/displacement_16.png"
        @_viewable.set true
        
        # attributes
        @add_attr
            _mesh: new Mesh( not_editable: true )
        
        @add_attr
            visualization: @_mesh.visualization
        
        
        
        @visualization.display_style.num.set 1
        

    display_suppl_context_actions: ( context_action )  ->
        #context_action.push new TreeAppModule_Mesher
        #context_action.push new TreeAppModule_Sketch
        #context_action.push new TreeAppModule_Transform
   
    accept_child: ( ch ) ->
        ch instanceof SketchItem or
        ch instanceof ImgItem

    z_index: ->
        @_mesh.z_index()
        
    sub_canvas_items: ->
        [ @_mesh ]

    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "_mesh", "visualization" ] )    
    
    # use on directory when browsing
    get_file_info: ( info ) ->
        info.model_type = "Mesh"
        info.icon = "mesh"

    draw: ( info ) ->
        app_data = @get_app_data()
        sel_items = app_data.selected_tree_items[0]
        if sel_items?.has_been_directly_modified()
            if sel_items[ sel_items.length-1 ] == this
                @colorize "blue"
            else
                @colorize() 

    colorize: ( color ) ->
        for drawable in @sub_canvas_items() 
            if color == "blue"
                drawable.visualization.line_color.r.val.set 77
                drawable.visualization.line_color.g.val.set 188
                drawable.visualization.line_color.b.val.set 233
            else
                drawable.visualization.line_color.r.val.set 255
                drawable.visualization.line_color.g.val.set 255
                drawable.visualization.line_color.b.val.set 255
                
    is_app_data: ( item ) ->
        if item instanceof TreeAppData
            return true
        else
            return false
       
    get_app_data: ->
        it = @get_parents_that_check @is_app_data
        return it[ 0 ] 