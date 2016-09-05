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
class Legend extends Drawable
    constructor: ( title = "Big title", show_legend = true, auto_fit = true )->
        super()
        
        @add_attr
            show_legend: show_legend
            color_map  : new Gradient
            auto_fit   : auto_fit
            legend_size       : new ConstrainedVal( 0.5, { min: 0.1, max: 1, div: 0 } )
            _title     : title
            _width     : 12
            _height    : 100 
            _min_val    : 0
            _max_val    : -1
            
        @add_attr
            max_val    : new ConstOrNotModel( @auto_fit, @_max_val, false )
            min_val    : new ConstOrNotModel( @auto_fit, @_min_val, false )

        @color_map.add_color [   0,   0,   0, 255 ], 0
        @color_map.add_color [ 255,   0,   0, 255 ], 0.33
        @color_map.add_color [ 255, 255,   0, 255 ], 0.66
        @color_map.add_color [ 255, 255, 255, 255 ], 1
        
        #         @color_map.add_color [ 255, 255, 255, 255 ], 0
        #         @color_map.add_color [   0,   0,   0, 255 ], 1
        
    z_index: ->
        return 1000

    is_correct: ->
        @max_val.get() >= @min_val.get()
        
    get_ratio: ( info ) ->
        info.h / ( @_height.get() * 2 ) * @legend_size.get()
    
    _draw_text_legend: ( info ) ->
        ratio = @get_ratio info
        height = @_height.get() * ratio
        width = @_width.get() * ratio
        
        pos_y = info.h * 0.5 - height * 0.5
        pos_x = info.w - 2.0 * width
        font_size = 10 * ratio 

        for c_s in @color_map.color_stop
            pos = c_s.position.get()
            val = ( @max_val.get() - @min_val.get() ) * ( 1 - c_s.position.get() ) + @min_val.get()
            info.cm.fillText val.toFixed( 4 ), pos_x - 8, pos_y + 7 + pos * height, font_size + "pt Arial", "right", "White"
            

    _draw_gradient: ( info, pos_x, pos_y, width, height ) ->
        if info.ctx_type == "2d"
            lineargradient = info.ctx.createLinearGradient 0, pos_y, 0, pos_y + height
            for col in @color_map.color_stop
                lineargradient.addColorStop col.position.get(), "rgba(#{col.color.r.get()}, #{col.color.g.get()}, #{col.color.b.get()}, #{col.color.a.get()})"
            info.ctx.fillStyle = lineargradient
            info.ctx.fillRect pos_x, pos_y, width, height
        else
            gl = info.ctx
            
            vs = "
                precision mediump float;\n
                varying float y;\n
                uniform float my;\n
                attribute vec3 pos;\n
                void main( void ) {\n
                    y = 0.5 * ( my * pos.y + 1.0 );\n
                    gl_Position = vec4( pos, 1.0 );\n
                }\n
            "
        
            fs = @color_map.get_fragment_shader "y"
            
            ps = info.cm.gl_prog vs, fs # bufferized :)
            ps.myUniform = gl.getUniformLocation ps, "my"

            # points
            _points = gl.createBuffer()
                
            gl.bindBuffer gl.ARRAY_BUFFER, _points
            
            z = -1.0
            x_min = 2.0 * pos_x / info.w - 1.0
            y_min = 1.0 - 2.0 * pos_y / info.h
            x_max = 2.0 * ( pos_x + width ) / info.w - 1.0
            y_max = 1.0 - 2.0 * ( pos_y + height ) / info.h
            array = new Float32Array [
                x_min, y_min, z,
                x_max, y_min, z,
                x_min, y_max, z,
                x_max, y_max, z
            ]
            
            gl.bufferData gl.ARRAY_BUFFER, array, gl.STATIC_DRAW

            # draw
            gl.useProgram ps
            gl.uniform1f ps.myUniform, info.h * 1.0 / height
            pos = gl.getAttribLocation ps, "pos"
            gl.enableVertexAttribArray pos
            
            gl.bindBuffer gl.ARRAY_BUFFER, _points
            gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
            gl.drawArrays gl.TRIANGLE_STRIP, 0, 4
            
            gl.deleteBuffer _points
            gl.disableVertexAttribArray pos
            gl.bindBuffer gl.ARRAY_BUFFER, null

    
    draw: ( info ) ->
        if @show_legend.get() == true
            # @color_map = info.theme.gradient_legend
            
            ratio = @get_ratio info
            height = @_height.get() * ratio
            width = @_width.get() * ratio
            
            pos_y = info.h * 0.5 - height * 0.5
            pos_x = info.w - 2.0 * width
            
            @_draw_gradient info, pos_x, pos_y, width, height
            @_draw_text_legend info
            
            t = @_title?.toString()
            if t?
                th = 10 * ratio
                info.cm.fillText t, pos_x + 0.5 * width, pos_y + height + th * 1.6, th + "pt Arial", "center-limited", "White"
