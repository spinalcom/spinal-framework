#
class GroundItem extends TreeItem
    constructor: ( name = "Ground" ) ->
        super()

        @_name.set name
        @_viewable.set true
        
        @add_attr
            # dimensions
            _width       : 40
            _height      : 0.5
            # centre du volume
            _point      : new PointMesher [ 0, 0, 0 ], 2, 6 
            
        @add_attr    
            _center      : @_point.point

        @add_attr 
            width : @_width
            height : @_height
            center : @_center
            _mesh   : new Mesh( not_editable: true )
             
        @add_attr          
            visualization : @_mesh.visualization

        @make_mesh()
        
        @_center.pos[0].set 0        
        @_center.pos[1].set ( - @_height / 2 )        
        @_center.pos[2].set 0          
        @visualization.display_style.num.set 2 

       
    make_mesh: ( )->
     
        @_mesh.points.clear()
        @_mesh._elements.clear()
        
        x = @_width.get() / 2 
        y = @_height.get() / 2 
        z = @_width.get() / 2 
        
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
        
        
     
            
            
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "_mesh", "visualization" ] )
    
    accept_child: ( ch ) ->
        
        
    sub_canvas_items: ->
        [ @_mesh ]

        
