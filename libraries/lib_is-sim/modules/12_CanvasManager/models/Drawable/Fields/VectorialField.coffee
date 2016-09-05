# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



# Vectorial fields is a list containing differents field
class VectorialField extends Drawable
    constructor: ( name = "", vector = new Lst, params = {} ) ->
        super()
        
        @add_attr
            _vector     : vector
    
        @_date_pts = {}
        @_pts_buffer = {}
            
    get_drawing_parameters: ( model ) ->
        if @_vector.length
#             @_vector[ 0 ].get_drawing_parameters model
#             model.visualization.add_attr
#                 norm: new Choice( 0, [ "norm_2" ] )

            model.add_attr
                drawing_parameters:
                    _legend: new Legend( model.name )
                    
            model.drawing_parameters.add_attr
                display_style: new Choice( 2, [ "Points", "Wireframe", "Surface", "Surface with Edges", "Arrow" ] )
                legend       : model.drawing_parameters._legend
        
#         model.add_attr
#             drawing_parameters:
#                 _legend: new Legend( "todo" )
#                 
#         model.drawing_parameters.add_attr
#             display_style: new Choice( 2, [ "Points", "Wireframe", "Surface", "Surface with Edges", "Arrow" ] )
#             gradient     : model.drawing_parameters._legend.color_map
#             legend       : model.drawing_parameters._legend
            
            
    get: ( a, b ) ->
        if a?
            if b?
                @_vector[ a ].get b
            else
                @_vector[ a ].get()
        else
            @_vector.get()

    # get vector for component i ()
    get_val: ( info, i, n = 3 ) ->
        for j in [ 0 ... n ]
            if j < @_vector.length
                @_vector[ j ].get_val info, i
            else
                0
        
    dim: ->
        if @_vector
            return @_vector.length
        return 0
    
    field_length: ( info ) ->
        if @_vector[ 0 ]?
            f = @_vector[ 0 ].get_sub_field info
            return f._data.size()
        
    
    add_child: ( child ) ->
        @_vector.push child
        
    rem_child: ( child ) ->
        ind = @_vector.indexOf child
        if ind > 0
            @_vector.splice ind, 1
    
#     get_value_of_fields_at_index: ( index ) ->
#         value = new Lst
#         if @dim() > 0
#             for field in @_vector.get()
#                 if field[ index ]?
#                     value.push field[ index ]
#                 else
#                     value.push 0
#         return value

    get_norm_value_at_index: ( info, index ) ->
        vector_value = @get_val info, index
        value = Math.sqrt( vector_value[ 0 ] * vector_value[ 0 ] + vector_value[ 1 ] * vector_value[ 1 ] )

    actualise_value_legend: ( info, legend, norm = true ) ->
        if norm
            # Warning, only works for a norm with two values
#             vector_values = []
            normalized_val = []
            len = @field_length info
            for i in [ 0 ... len ]
                normalized_val[ i ] = @get_norm_value_at_index info, i

            max = @_get_max normalized_val
            min = @_get_min normalized_val
            legend.min_val.set min
            legend.max_val.set max
        else
            @_vector[ 0 ].actualise_value_legend_all_fields legend
    
    z_index: () ->
        return 175
    
    draw: ( info, parameters, additionnal_parameters ) ->
        
        if parameters?
            @actualise_value_legend info, parameters._legend,  true
            
            ###if info.ctx_type == "gl"
                nn = -1
                for el in @_mesh._elements when el.indices._data?
                    @_update_gl_bufs info, ( nn += 1 ), el
                    ni = nn + "_" + info.ctx.ctx_id
                    w = if additionnal_parameters?.warp_by? and additionnal_parameters?.warp_factor
                        additionnal_parameters.warp_by
                    el.draw_nodal_field_gl? info, @_mesh, @_mesh.points, @_data_buffer[ ni ], parameters.display_style.get(), parameters._legend, w, additionnal_parameters.warp_factor, ni
                    
            else ###       
            if @dim() >= 2
                warp_factor = 0
                if additionnal_parameters?.warp_by?
                    warp_factor = additionnal_parameters.warp_factor
                sub_field = @_vector[ 0 ].get_sub_field info
                if sub_field._mesh?.points? and sub_field._data?._data?
                    @draw_vectorial_field info, parameters.display_style.get(), sub_field._mesh.points, sub_field._data._data, parameters._legend, warp_factor
                          
            # legend
            parameters._legend.draw info
    
    _update_gl_bufs: ( info, nn, el ) ->
        gl = info.ctx
        ni = nn + "_" + gl.ctx_id

        if not @_date_bufs[ ni ]?
            @_date_bufs[ ni ] = -1
            
        if @_date_bufs[ ni ] < @_data._date_last_modification or @_date_bufs[ ni ] < @_mesh._date_last_modification
            @_date_bufs[ ni ] = Model._counter
            
            if @_data_buffer[ ni ]?
                gl.deleteBuffer @_data_buffer[ ni ]
                
            @_data_buffer[ ni ] = gl.createBuffer()
            gl.bindBuffer gl.ARRAY_BUFFER, @_data_buffer[ ni ]
            
            ne = el._get_indices()._data.length
            val = new Float32Array ne
            for i in [ 0 ... ne ]
                val[ i ] = @_data._data[ el._get_indices().get i ]
            
            gl.bufferData gl.ARRAY_BUFFER, val, gl.STATIC_DRAW
    
    
    draw_vectorial_field: ( info, display_style, points, values, legend, warp_factor = 1, norm = true ) ->
        if display_style == "Arrow"
            color = "white"
            
            arrow_reduce = 0.3
            arrow_width_factor = 0.1
            
            for p, ind in points
                element = new Lst
                for int_field, i in @_vector
                    data = int_field.get_sub_field( info )._data._data
                    element.push data[ ind ] * warp_factor
                if element.length == 2
                    element.push 0
                     
                proj_p0 = info.re_2_sc.proj p.pos.get()
                proj_p1 = info.re_2_sc.proj Vec_3.add( p.pos.get(), element.get() )
                
                orthogo = [ proj_p0[ 1 ] - proj_p1[ 1 ], proj_p1[ 0 ] - proj_p0[ 0 ] ]

                arrow_p0 = [
                    ( 1 - arrow_reduce ) * proj_p1[ 0 ] + arrow_reduce * proj_p0[ 0 ] + arrow_width_factor * orthogo[ 0 ],
                    ( 1 - arrow_reduce ) * proj_p1[ 1 ] + arrow_reduce * proj_p0[ 1 ] + arrow_width_factor * orthogo[ 1 ]
                ]
                arrow_p1 = [
                    ( 1 - arrow_reduce ) * proj_p1[ 0 ] + arrow_reduce * proj_p0[ 0 ] - arrow_width_factor * orthogo[ 0 ],
                    ( 1 - arrow_reduce ) * proj_p1[ 1 ] + arrow_reduce * proj_p0[ 1 ] - arrow_width_factor * orthogo[ 1 ]
                ]
                
                max_legend = legend.max_val.get()
                min_legend = legend.min_val.get()
                
                
                if norm
                    norm_values = []
                    for val, i in values
                        norm_values[ i ] = @get_norm_value_at_index info, i
                    position = ( max_legend - norm_values[ ind ] ) / ( max_legend - min_legend )
                else
                    position = ( max_legend - values[ ind ] ) / ( max_legend - min_legend )
                    
                color = legend.color_map.get_color_from_pos position
                @_draw_arrow_colored info, proj_p0, proj_p1, arrow_p0, arrow_p1, color
            
    warp_gl_buff: ( info, el, buff_id ) ->
        gl = info.ctx
        if not @_date_pts[ buff_id ]?
            @_date_pts[ buff_id ] = -1
        
        if @_date_pts[ buff_id ] < @_vector._date_last_modification
            @_date_pts[ buff_id ] = @_vector._date_last_modification
            # mesh = @_vector[ 0 ].get_sub_field( info )._mesh
            
            dim = 3
            cpp = -1
            pts = new Float32Array el._get_indices().size( 0 ) * dim * el._get_indices().size( 1 )
            for i in [ 0 ... el._get_indices().size( 1 ) ]
                for nn in [ 0 ... el._get_indices().size( 0 ) ]
                    ni = el._get_indices().get [ nn, i ]
                    
                    pts[ cpp += 1 ] = if @_vector[ 0 ]? then @_vector[ 0 ].get_sub_field( info ).get_val( info, ni ) else 0
                    pts[ cpp += 1 ] = if @_vector[ 1 ]? then @_vector[ 1 ].get_sub_field( info ).get_val( info, ni ) else 0
                    pts[ cpp += 1 ] = if @_vector[ 2 ]? then @_vector[ 2 ].get_sub_field( info ).get_val( info, ni ) else 0

            if @_pts_buffer[ buff_id ]?
                gl.deleteBuffer @_pts_buffer[ buff_id ]
                
            @_pts_buffer[ buff_id ] = gl.createBuffer()
            gl.bindBuffer gl.ARRAY_BUFFER, @_pts_buffer[ buff_id ]
            gl.bufferData gl.ARRAY_BUFFER, pts, gl.STATIC_DRAW
            
        @_pts_buffer[ buff_id ]
        
    _draw_arrow_colored: ( info, p0, p1, arrow_p0, arrow_p1, color ) ->
        info.ctx.beginPath()
        info.ctx.lineWidth = 1
        info.ctx.strokeStyle = "rgba( " + color[ 0 ] + ", " + color[ 1 ] + ", " + color[ 2 ] + ", " + color[ 3 ] + " ) "
        info.ctx.moveTo( p0[ 0 ], p0[ 1 ] )
        info.ctx.lineTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.stroke()
        
        #drawing arrow
        info.ctx.fillStyle = "rgba( " + color[ 0 ] + ", " + color[ 1 ] + ", " + color[ 2 ] + ", " + color[ 3 ] + " ) "
        info.ctx.lineWidth = 0.8        
        info.ctx.moveTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.lineTo( arrow_p0[ 0 ], arrow_p0[ 1 ] )
        info.ctx.lineTo( arrow_p1[ 0 ], arrow_p1[ 1 ] )
        info.ctx.lineTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
        
        info.ctx.closePath()
        
    _get_max: ( l ) ->
        if l.length > 0
            max = l[ 0 ]
        for i in [ 1 ... l.length ]
            val = l[ i ]
            if val > max
                max = val
        return max
        
    _get_min: ( l ) ->
        if l.length > 0
            min = l[ 0 ]
        for i in [ 1 ... l.length ]
            val = l[ i ]
            if val < min
                min = val
        return min
        