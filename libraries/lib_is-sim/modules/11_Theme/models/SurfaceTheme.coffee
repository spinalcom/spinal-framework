# Copyright 2015 SpinalCom  www.spinalcom.com

#
# This file is part of SpinalCore.
#
# SpinalCore is free software: you can redistribute it and/or modify
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
class SurfaceTheme extends Model
    constructor: ( color = new Color( 200, 200, 200, 255 ) ) ->
        super()
        
        @add_attr
            color: color

    beg_ctx: ( info ) ->
        if info.ctx_type == "2d"
            info.ctx.fillStyle = @color.to_rgba()
            info.ctx.strokeStyle = @color.to_rgba()
        
    end_ctx: ( info ) ->
        
    draw: ( info, func ) ->
        info.ctx.beginPath()
        func info
        info.ctx.fill()
        info.ctx.stroke()
        
    draw_triangle: ( info, p0, p1, p2, col = [ 0.9, 0.9, 0.9 ] ) ->
        vs = "
            precision mediump float;\n
            attribute vec3 pos;\n
            void main( void ) {\n
                gl_Position = vec4( pos, 1.0 );\n
            }\n
        "
    
        fs = "
            precision mediump float;\n
'           uniform vec4 col;\n
            void main( void ) {\n
                gl_FragColor = col;\n
            }
        "
        
        ps = info.cm.gl_prog vs, fs # bufferized :)
        
        # points
        gl = info.ctx
        
        points = gl.createBuffer()
        gl.bindBuffer gl.ARRAY_BUFFER, points

        array = new Float32Array [
            2.0 * p0[ 0 ] / info.w - 1.0, 1.0 - 2.0 * p0[ 1 ] / info.h, p0[ 2 ],
            2.0 * p1[ 0 ] / info.w - 1.0, 1.0 - 2.0 * p1[ 1 ] / info.h, p1[ 2 ],
            2.0 * p2[ 0 ] / info.w - 1.0, 1.0 - 2.0 * p2[ 1 ] / info.h, p2[ 2 ]
        ]
        
        gl.bufferData gl.ARRAY_BUFFER, array, gl.STATIC_DRAW

        # draw
        gl.useProgram ps
        pos = gl.getAttribLocation ps, "pos"
        gl.enableVertexAttribArray pos
        
        pcol = gl.getUniformLocation ps, "col"
        gl.uniform4f pcol, col[ 0 ], col[ 1 ], col[ 2 ], 1.0


        gl.bindBuffer gl.ARRAY_BUFFER, points
        gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
        gl.drawArrays gl.TRIANGLE_STRIP, 0, 3

        gl.deleteBuffer points
        gl.bindBuffer gl.ARRAY_BUFFER, null
        gl.disableVertexAttribArray pos
    
