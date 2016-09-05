#
class FlatItem extends TreeItem
    constructor: ( name = "Flat") ->
        super()

        @_name.set name
        @_viewable.set true
        
        @add_attr
            name : @_name
            construction : new ConstrainedVal( 0, { min: 0, max: 2 } ) 
            fire_detection : new ConstrainedVal( 0, { min: 0, max: 1 } ) 
        
        @add_attr
            # dimensions
            _length       : 3.0
            _width       : 2.0
            _height      : 1.0
            # centre du volume
            _point      : new PointMesher [ 0, 0, 0 ], 2, 6 
            
        @add_attr    
            _center : @_point.point
  
            _mesh   : new Mesh( not_editable: true )            
            _data_visualization : new Choice( 0, [ "Selection", "Construction", "Fire Detection"] )
        
        @add_attr
            length  : @_length
            width  : @_width
            height : @_height
            center : @_center
            visualization : @_mesh.visualization     
            _is_selected: 0
            _is_ok: 0

        # données de couleur
        @add_attr
            color:
                r: 236
                g: 236
                b: 236
        
        @normal_display()


    make_mesh: ( )->
     
        @_mesh.points.clear()
        @_mesh._elements.clear()
        
        x = (@_width.get() - 0.2 ) / 2 
        y = (@_height.get() - 0.2 ) / 2 
        z = (@_length.get() - 0.2 ) / 2 
        
        x_c = @_center.pos[0].get()
        y_c = @_center.pos[1].get()
        z_c = @_center.pos[2].get()
        
        

        @_mesh.add_point [ x_c - x, y_c - y, z_c - z ]
        @_mesh.add_point [ x_c - x, y_c + y, z_c - z ]
        @_mesh.add_point [ x_c + x, y_c - y, z_c - z ]
        @_mesh.add_point [ x_c + x, y_c + y, z_c - z ]
        
        @_mesh.add_point [ x_c + x, y_c - y, z_c + z ]
        @_mesh.add_point [ x_c + x, y_c + y, z_c + z ]
        @_mesh.add_point [ x_c - x, y_c - y, z_c + z ]
        @_mesh.add_point [ x_c - x, y_c + y, z_c + z ]
        



        @_mesh.add_point [ x_c + x, y_c + y, z_c + z ]
        @_mesh.add_point [ x_c + x, y_c + y, z_c - z ]
        @_mesh.add_point [ x_c - x, y_c + y, z_c + z ]
        @_mesh.add_point [ x_c - x, y_c + y, z_c - z ]
        
        @_mesh.add_point [ x_c - x, y_c - y, z_c + z ]
        @_mesh.add_point [ x_c - x, y_c - y, z_c - z ]
        @_mesh.add_point [ x_c + x, y_c - y, z_c + z ]
        @_mesh.add_point [ x_c + x, y_c - y, z_c - z ]   
                    
                    
                    
        el = new Element_TriangleList
        el.indices.resize [ 3, 36 ]
        num_element = 0
        for i in [ 0 ... 6 ]
            for j in [ 0 ... 3 ]
                pt_1 = i * 2 + j
                pt_2 = i * 2 + (j+1)
                pt_3 = (i+1) * 2 + j
                pt_4 = (i+1) * 2 + (j+1)
                
                el.indices.set_val [ 0, num_element ], pt_1
                el.indices.set_val [ 1, num_element ], pt_3
                el.indices.set_val [ 2, num_element ], pt_2
                
                num_element += 1
                
                el.indices.set_val [ 0, num_element ], pt_4
                el.indices.set_val [ 1, num_element ], pt_2
                el.indices.set_val [ 2, num_element ], pt_3
                
                num_element += 1
                
        @_mesh.add_element el
        

    draw: ( info ) ->
        app_data = @get_app_data()
        sel_items = app_data.selected_tree_items[0]
        
        if sel_items?.has_been_directly_modified()
            if sel_items[ sel_items.length-1 ] == this
                @_is_selected.set 1
            else
                @_is_selected.set 0
            
        if @_width.has_been_modified() or @_length.has_been_modified() or @_height.has_been_modified() or @_center.has_been_modified()
            @make_mesh() 
            
        if @_data_visualization.has_been_modified()
            @clear_visu()
            if @_data_visualization.num.get() == 1
                @construct_building_1()            
            else if @_data_visualization.num.get() == 2
                @detect_fires()
                
        if @_data_visualization.num.get() == 0 
            @normal_display()       
        if @_data_visualization.num.get() == 1 
            @construct_building_1()                
        if @_data_visualization.num.get() == 2 
            @detect_fires()        
        
    
    normal_display: () ->    
        
        if @_is_selected.get() == 1
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 61
            @visualization.element_color.g.val.set 134
            @visualization.element_color.b.val.set 246
            @visualization.element_color.a.val.set 255
        
        else if @fire_detection.get() == 1
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 255
            @visualization.element_color.g.val.set 0
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255        
        
        else if @_is_ok.get() == 1
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 0
            @visualization.element_color.g.val.set 205
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255              
        
        else 
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set @color.r.get()
            @visualization.element_color.g.val.set @color.g.get()
            @visualization.element_color.b.val.set @color.b.get()
            @visualization.element_color.a.val.set 255  
            
        
    
    # affichage "maillage"    
    construct_building_1: () ->    
        if @construction.get() == 0
            @visualization.display_style.num.set 1 
            @visualization.element_color.r.val.set 155
            @visualization.element_color.g.val.set 155
            @visualization.element_color.b.val.set 155
            @visualization.element_color.a.val.set 255
            
        else if @construction.get() == 1
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 205
            @visualization.element_color.g.val.set 0
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255
            
        else if @construction.get() == 2
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 0
            @visualization.element_color.g.val.set 205
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255            
            
    # affichage "transparent"        
    construct_building_2: () ->    
        if @construction.get() == 0
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 155
            @visualization.element_color.g.val.set 155
            @visualization.element_color.b.val.set 155
            @visualization.element_color.a.val.set 255
            
        else if @construction.get() == 1
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 205
            @visualization.element_color.g.val.set 0
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255
            
        else if @construction.get() == 2
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 0
            @visualization.element_color.g.val.set 205
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255    
            
    # affichage "transparent" + "maillage"        
    construct_building_3: () ->    
        if @construction.get() == 0
            @visualization.display_style.num.set 3 
            @visualization.element_color.r.val.set 155
            @visualization.element_color.g.val.set 155
            @visualization.element_color.b.val.set 155
            @visualization.element_color.a.val.set 30
            
        else if @construction.get() == 1
            @visualization.display_style.num.set 3 
            @visualization.element_color.r.val.set 205
            @visualization.element_color.g.val.set 0
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 130
            
        else if @construction.get() == 2
            @visualization.display_style.num.set 3 
            @visualization.element_color.r.val.set 0
            @visualization.element_color.g.val.set 205
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255 
    
    # affichage des incendies
    detect_fires: () ->    
    
        if @fire_detection.get() == 0
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 155
            @visualization.element_color.g.val.set 155
            @visualization.element_color.b.val.set 155
            @visualization.element_color.a.val.set 255

        if @fire_detection.get() == 1
            @visualization.display_style.num.set 2 
            @visualization.element_color.r.val.set 205
            @visualization.element_color.g.val.set 0
            @visualization.element_color.b.val.set 0
            @visualization.element_color.a.val.set 255
    
    # raz affichage
    clear_visu: () ->
        @visualization.display_style.num.set 2 
        @visualization.element_color.r.val.set 155
        @visualization.element_color.g.val.set 155
        @visualization.element_color.b.val.set 155
        @visualization.element_color.a.val.set 30
            
            
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "_mesh", "visualization" ] )
    
    #accept_child: ( ch ) ->
    #    ch instanceof ReservationItem
        
    sub_canvas_items: ->
        [ @_mesh ]

    # pour récupérer le modèle global (TreeAppData) 
    is_app_data: ( item ) ->
        if item instanceof TreeAppData
            return true
        else
            return false
       
    # pour récupérer le modèle global (TreeAppData) 
    get_app_data: ->
        #get app_data
        it = @get_parents_that_check @is_app_data
        return it[ 0 ]  
