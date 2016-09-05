#
class GridItem extends TreeItem
    constructor: ( name = "Grid" ) ->
        super()
         
        @_name.set name
#         @_ico.set "img/note.png"
        @_viewable.set true
        
        
        @add_attr
            graph_attr :
                line_color       : new Color 0, 0, 0
                line_width       : new ConstrainedVal( 1, { min: 0, max: 20 } )
                shadow           : false
                show_marker      : true
                marker           : new Choice( 0, [ "dot", "square", "cross", "diamond", "bar" ] )
                marker_size      : new ConstrainedVal( 5, { min: 0, max: 40 } )
                marker_color     : new Color 0, 0, 0
                line_width    : new ConstrainedVal( 1, { min: 1, max: 5 } )
                marker_size   : new ConstrainedVal( 1, { min: 1, max: 50 } )
                font_size   : new ConstrainedVal( 20, { min: 5, max: 30 } )
                legend_x_division: new ConstrainedVal( 10, { min: 1, max: 30 } )
                legend_y_division: new ConstrainedVal( 10, { min: 1, max: 30 } )
            _point1       : new PointMesher [ 0, 0, 0 ], 2, 6
            _point2       : new PointMesher [ 2, 0, 0 ], 2, 6
            #point3 : new Point [ 10, 10, 0 ]
            #point4 : new Point [ 10, 0, 0 ]
        
        @add_attr
            point1 : @_point1.point
            point2 : @_point2.point
            _graph : new Graph 
                  marker: 'dot',
                  marker_color: "#f00"
                  line_width  : @graph_attr.line_width,
                  line_color: "#f00"
                  marker_size: @graph_attr.marker_size,
                  font_size : @graph_attr.font_size,
                  legend_x_division: 10,
                  legend_y_division: 10,
                  x_axis: 'x',
                  y_axis: 'y'
        
        @_graph.marker = @graph_attr.marker
        @_graph.marker_color = @graph_attr.marker_color
        @_graph.line_width = @graph_attr.line_width
        @_graph.line_color = @graph_attr.line_color
        @_graph.marker_size = @graph_attr.marker_size
        
        @_graph.points.push @point1
        @_graph.points.push @point2
        #@_graph.points.push @point3
        #@_graph.points.push @point4
        
        @_graph.points[0] = @point1
        @_graph.points[1] = @point2
        #@_graph.points[2] = @point3
        #@_graph.points[3] = @point4
        
        
    accept_child: ( ch ) ->
        false
    
    sub_canvas_items: ->
        [ @_graph, @_point1, @_point2 ]
        
        
    draw: ( info ) ->
          draw_point = info.sel_item[ @model_id ]
          if @_graph.points.length && draw_point
                  for pm in @_graph.points
                                  pm.draw info
        
    get_movable_entities: ( res, info, pos, phase ) ->
        for pm in @_point1
            pm.get_movable_entities res, info, pos, phase
        for pm in @_point2
            pm.get_movable_entities res, info, pos, phase
            
    on_mouse_down: ( cm, evt, pos, b ) ->
        for pm in @_point1
            pm.on_mouse_down cm, evt, pos, b
        for pm in @_point2
            pm.on_mouse_down cm, evt, pos, b
        return false
            
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        for pm in @_point1
            pm.on_mouse_move cm, evt, pos, b, old
        for pm in @_point2
            pm.on_mouse_move cm, evt, pos, b, old
        return false    
        