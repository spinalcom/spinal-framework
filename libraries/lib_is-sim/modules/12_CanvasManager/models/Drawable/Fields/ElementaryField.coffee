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



# 
class ElementaryField extends Model
    constructor: ( mesh ) ->
        super()
        
        @add_attr
            _mesh: mesh
            _data: new TypedArray_Float64( mesh?.nb_elements() )
            
        @_date_bufs = {}
        @_data_buffer = {}

    get_drawing_parameters: ( model ) ->
        model.add_attr
            drawing_parameters:
                _legend: new Legend( model.name )
                
        model.drawing_parameters.add_attr
            display_style: new Choice( 1, [ "Wireframe", "Surface", "Surface with Edges" ] )
            legend       : model.drawing_parameters._legend
    
    get_sub_field: ( info ) ->
        this
    
    update_min_max: ( x_min, x_max ) ->
        @_mesh.update_min_max x_min, x_max
        
    toString: ->
        @name.get()
    
    get: () ->
        @_data.get()
        
    sub_canvas_items: ->
        if @drawing_parameters?
            [ @drawing_parameters._legend ]
        else
            []
            
    z_index: () ->
        return 140
        
    get_val: ( info, i ) ->
        @_data.get i
        
    draw: ( info, parameters, additionnal_parameters ) ->
        if parameters?
            @actualise_value_legend parameters._legend
            
            if info.ctx_type == "gl"
                nn = -1
                offset_el = 0
                for el in @_mesh._elements when el.indices._data?
                    @_update_gl_bufs info, ( nn += 1 ), el, offset_el
                    ni = nn + "_" + info.ctx.ctx_id
                    w = if additionnal_parameters?.warp_by? and additionnal_parameters?.warp_factor
                        additionnal_parameters.warp_by
                    el.draw_nodal_field_gl? info, @_mesh, @_mesh.points, @_data_buffer[ ni ], parameters.display_style.get(), parameters._legend, w, additionnal_parameters.warp_factor, ni
                    offset_el += el.indices.size 1
            else
                # projection points
                proj = if additionnal_parameters?.warp_by? and @_mesh.points.length == additionnal_parameters.warp_by._vector[ 0 ]?._data[ 0 ]?.field?._data.size()?[ 0 ]
                    for p, i in @_mesh.points
                        info.re_2_sc.proj Vec_3.add p.pos.get(), Vec_3.mus( additionnal_parameters.warp_factor, additionnal_parameters.warp_by.get_val( info, i, 3 ) )
                else
                    for p, i in @_mesh.points
                        info.re_2_sc.proj p.pos.get()
                for el in @_mesh._elements
                    el.draw_elementary_triangle? info, proj, @_data, parameters.display_style.get(), parameters._legend
                
            # legend
            parameters._legend.draw info
    
    
    actualise_value_legend: ( legend ) ->
        if @_data.has_been_modified() or not legend.is_correct()
            min = @get_min_data()
            legend.min_val.set min
        
            max = @get_max_data()
            legend.max_val.set max
        
    get_min_data: ->
        @_get_min @_data.get()
        
    get_max_data: ->
        @_get_max @_data.get()

    _update_gl_bufs: ( info, nn, el, offset_el ) ->
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
            
            cpe = -1
            ne  = el.indices._data.length
            val = new Float32Array ne
            for i in [ 0 ... el.indices.size( 1 ) ]
                for j in [ 0 ... el.indices.size( 0 ) ]
                    val[ cpe += 1 ] = @_data._data[ i + offset_el ]
            
            gl.bufferData gl.ARRAY_BUFFER, val, gl.STATIC_DRAW
        
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
            
    