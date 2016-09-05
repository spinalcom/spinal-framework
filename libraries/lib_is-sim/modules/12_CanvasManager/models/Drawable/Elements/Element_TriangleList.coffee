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
class Element_TriangleList extends Element
    constructor: ->
        super()
        
        @add_attr
            indices: new TypedArray_Int32 [ 3, 0 ]
            
        @_date_pts = {}
        @_pts_buffer = {}
        @_nor_buffer = {}
        @_lns_buffer = {}
            
    draw_gl: ( info, mesh, points, is_a_sub ) ->
        if @_get_indices() and mesh.get_point 0
            # need to update the arrays ?
            @_update_bufs info, mesh, points
            
            gl = info.ctx   
            # 

            if mesh.visualization.display_style.get() in [ "Points", "Wireframe", "Surface", "Surface with Edges" ]
                vs = "
                    precision mediump float;\n
                    attribute vec3 pos;\n
                    attribute vec3 nor;\n
                    varying vec3 norin;\n
                    #{ info.cam.gl_attr_vec info, "can" }\n
                    #{ info.cam.gl_attr info, "cam" }\n
                    void main( void ) {\n
                        gl_Position = vec4( pos, 1.0 );\n
                        #{ info.cam.gl_main_vec info, "can", "nor", "norin" }\n
                        #{ info.cam.gl_main info, "cam" }\n
                    }\n
                "
            
                fs = "
                    precision mediump float;\n
                    uniform vec4 col;\n
                    varying vec3 norin;\n
                    void main( void ) {\n
                        float g = abs( norin[ 2 ] );\n
                        gl_FragColor = vec4( g * col[ 0 ], g * col[ 1 ], g * col[ 2 ], col[ 3 ] );\n
                    }\n
                "
                
                ps = info.cm.gl_prog vs, fs # bufferized :)
                
                # draw
                gl.useProgram ps
                
                pos = gl.getAttribLocation ps, "pos"
                gl.enableVertexAttribArray pos
                gl.bindBuffer gl.ARRAY_BUFFER, @_pts_buffer[ gl.ctx_id ]
                gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
                
                nor = gl.getAttribLocation ps, "nor"
                gl.enableVertexAttribArray nor
                gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ]
                gl.vertexAttribPointer nor, 3, gl.FLOAT, false, 0, 0
                
                col = gl.getUniformLocation ps, "col"
                #gl.uniform4f col, 0.7, 0.7, 0.7, 1.0
    #             console.log mesh.theme.surfaces.color.r.get()
                mesh_color = mesh._theme.surfaces.color
                @line_color = mesh._theme.lines.color
                gl.uniform4f col, mesh_color.r.get()/255, mesh_color.g.get()/255, mesh_color.b.get()/255, mesh_color.a.get()/255
                
                info.cam.gl_exec info, "cam", ps
                info.cam.gl_exec_vec info, "can", ps
            
                if mesh.visualization.display_style.get() in [ "Surface", "Surface with Edges"]
                    gl.drawArrays gl.TRIANGLES, 0, 3 * @indices.size( 1 )
                    #gl.drawArrays gl.GL_TRIANGLES_ADJACENCY, 0, 3 * @indices.size( 1 )
                    
                    #             console.log gl.getError()
                
                
            if mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
                @_draw_lines info

            if mesh.visualization.display_style.get() in [ "Points" ]
                @_draw_points info


    # 2D canvas                
    draw: ( info, mesh, proj, is_a_sub ) ->
        if @_get_indices()
        
            if mesh.visualization.display_style.get() in [ "Surface", "Surface with Edges" ]
                lt = for i in [ 0 ... @indices.size( 1 ) ]
                    [
                        proj[ @indices.get [ 0, i ] ]
                        proj[ @indices.get [ 1, i ] ]
                        proj[ @indices.get [ 2, i ] ]
                    ]

                lt.sort ( a, b ) -> ( b[ 0 ][ 2 ] + b[ 1 ][ 2 ] + b[ 2 ][ 2 ] ) - ( a[ 0 ][ 2 ] + a[ 1 ][ 2 ] + a[ 2 ][ 2 ] )
                info.theme.surfaces.beg_ctx info
                for pl in lt
                    info.theme.surfaces.draw info, =>
                        info.ctx.moveTo pl[ 0 ][ 0 ], pl[ 0 ][ 1 ]
                        info.ctx.lineTo pl[ 1 ][ 0 ], pl[ 1 ][ 1 ]
                        info.ctx.lineTo pl[ 2 ][ 0 ], pl[ 2 ][ 1 ]
                        info.ctx.lineTo pl[ 0 ][ 0 ], pl[ 0 ][ 1 ]
                info.theme.surfaces.end_ctx info

            if mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
                info.theme.lines.beg_ctx info
                
                for i in [ 0 ... @indices.size( 1 ) ]
                    p = for j in [ 0 ... 3 ]
                        proj[ @indices.get [ j, i ] ]
                        
                    info.theme.lines.draw_straight_proj info, p[ 0 ], p[ 1 ]
                    info.theme.lines.draw_straight_proj info, p[ 1 ], p[ 2 ]
                    info.theme.lines.draw_straight_proj info, p[ 2 ], p[ 0 ]

                info.theme.lines.end_ctx info

    # 
    draw_nodal_field_gl: ( info, mesh, points, data, display_style, legend, warp_by, warp_factor = 1, buff_id ) ->
        if @_get_indices()
    
            warp_buff = warp_by?.warp_gl_buff info, this, buff_id
                
            @_update_bufs info, mesh, points
            gl = info.ctx
        
            if display_style in [ "Surface", "Surface with Edges" ]
                vs = "
                    precision mediump float;\n
                    varying float y;\n
                    varying vec3 norin;\n
                    uniform float mit;\n
                    uniform float mat;\n
                    uniform float waf;\n
                    attribute vec3 pos;\n
                    attribute vec3 nor;\n
                    attribute vec3 wab;\n
                    attribute float tex;\n
                    #{ info.cam.gl_attr_vec info, "can" }\n
                    #{ info.cam.gl_attr info, "cam" }\n
                    void main( void ) {\n
                        y = ( tex - mit ) / ( mat - mit );\n
                        gl_Position = vec4( pos + waf * wab, 1.0 );\n
                        #{ info.cam.gl_main_vec info, "can", "nor", "norin" }\n
                        #{ info.cam.gl_main info, "cam" }\n
                    }\n
                "
                fs = legend.color_map.get_fragment_shader "y", "col", "norin"
                
                ps = info.cm.gl_prog vs, fs # bufferized :)
                
                gl.useProgram ps
                
                pos = gl.getAttribLocation ps, "pos"
                gl.enableVertexAttribArray pos
                gl.bindBuffer gl.ARRAY_BUFFER, @_pts_buffer[ gl.ctx_id ]
                gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
                
                nor = gl.getAttribLocation ps, "nor"
                gl.enableVertexAttribArray nor
                gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ]
                gl.vertexAttribPointer nor, 3, gl.FLOAT, false, 0, 0
                
                
                wab = gl.getAttribLocation ps, "wab"
                gl.enableVertexAttribArray wab
                if warp_buff?
                    gl.bindBuffer gl.ARRAY_BUFFER, warp_buff
                else
                    gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ] # dummy buff
                gl.vertexAttribPointer wab, 3, gl.FLOAT, false, 0, 0
                
                tex = gl.getAttribLocation ps, "tex"
                if tex >= 0
                    gl.enableVertexAttribArray tex
                    gl.bindBuffer gl.ARRAY_BUFFER, data
                    gl.vertexAttribPointer tex, 1, gl.FLOAT, false, 0, 0
                
                col = gl.getUniformLocation ps, "col"
                gl.uniform4f col, 0.7, 0.7, 0.7, 1.0
                
                gl.uniform1f gl.getUniformLocation( ps, "mit" ), legend._min_val.get()
                gl.uniform1f gl.getUniformLocation( ps, "mat" ), legend._max_val.get()
                gl.uniform1f gl.getUniformLocation( ps, "waf" ), warp_factor
                
                info.cam.gl_exec info, "cam", ps
                info.cam.gl_exec_vec info, "can", ps
            
                gl.drawArrays gl.TRIANGLES, 0, 3 * @indices.size( 1 )
                
                gl.disableVertexAttribArray pos
                gl.disableVertexAttribArray nor
                gl.disableVertexAttribArray wab
                gl.disableVertexAttribArray tex
                
            if display_style in [ "Wireframe", "Surface with Edges" ]
                @_draw_lines info
            
            
    draw_vectorial_field_gl: ( info, mesh, points, data, display_style, legend, warp_by, warp_factor = 1, buff_id ) ->
        if @_get_indices()
        
            warp_buff = warp_by?.warp_gl_buff info, this, buff_id
                
            gl = info.ctx
            if not @_date_pts[ gl.ctx_id ]?
                @_date_pts[ gl.ctx_id ] = -1
            
            if @_date_pts[ gl.ctx_id ] < mesh._date_last_modification
                @_date_pts[ gl.ctx_id ] = mesh._date_last_modification
                
                dim = 3
                cpp = -1
                pts = new Float32Array 2 * dim * points.length
            
                for i in [ 0 ... points.length ]
                    
                    pts[ cpp += 1 ] = points[ i ].pos[0].get()
                    pts[ cpp += 1 ] = points[ i ].pos[1].get()
                    pts[ cpp += 1 ] = points[ i ].pos[2].get()
                    pts[ cpp += 1 ] = points[ i ].pos[0].get() #+ warp_by
                    pts[ cpp += 1 ] = points[ i ].pos[1].get() #+ warp_by
                    pts[ cpp += 1 ] = points[ i ].pos[2].get() #+ warp_by
                    
                    

                if @_pts_buffer[ gl.ctx_id ]?
                    gl.deleteBuffer @_pts_buffer[ gl.ctx_id ]
                    gl.deleteBuffer @_nor_buffer[ gl.ctx_id ]
                    gl.deleteBuffer @_lns_buffer[ gl.ctx_id ]
                    
                @_pts_buffer[ gl.ctx_id ] = gl.createBuffer()
                gl.bindBuffer gl.ARRAY_BUFFER, @_pts_buffer[ gl.ctx_id ]
                gl.bufferData gl.ARRAY_BUFFER, pts, gl.STATIC_DRAW
                
                @_nor_buffer[ gl.ctx_id ] = gl.createBuffer()
                gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ]
                gl.bufferData gl.ARRAY_BUFFER, nor, gl.STATIC_DRAW
                
                @_lns_buffer[ gl.ctx_id ] = gl.createBuffer()
                gl.bindBuffer gl.ARRAY_BUFFER, @_lns_buffer[ gl.ctx_id ]
                gl.bufferData gl.ARRAY_BUFFER, lns, gl.STATIC_DRAW
                
                
        
            if display_style in [ "Surface", "Surface with Edges" ]
                vs = "
                    precision mediump float;\n
                    varying float y;\n
                    varying vec3 norin;\n
                    uniform float mit;\n
                    uniform float mat;\n
                    uniform float waf;\n
                    attribute vec3 pos;\n
                    attribute vec3 nor;\n
                    attribute vec3 wab;\n
                    attribute float tex;\n
                    #{ info.cam.gl_attr_vec info, "can" }\n
                    #{ info.cam.gl_attr info, "cam" }\n
                    void main( void ) {\n
                        y = ( tex - mit ) / ( mat - mit );\n
                        gl_Position = vec4( pos + waf * wab, 1.0 );\n
                        #{ info.cam.gl_main_vec info, "can", "nor", "norin" }\n
                        #{ info.cam.gl_main info, "cam" }\n
                    }\n
                "
                fs = legend.color_map.get_fragment_shader "y", "col", "norin"
                
                ps = info.cm.gl_prog vs, fs # bufferized :)
                
                gl.useProgram ps
                
                pos = gl.getAttribLocation ps, "pos"
                gl.enableVertexAttribArray pos
                gl.bindBuffer gl.ARRAY_BUFFER, @_pts_buffer[ gl.ctx_id ]
                gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
                
                nor = gl.getAttribLocation ps, "nor"
                gl.enableVertexAttribArray nor
                gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ]
                gl.vertexAttribPointer nor, 3, gl.FLOAT, false, 0, 0
                
                
                wab = gl.getAttribLocation ps, "wab"
                gl.enableVertexAttribArray wab
                if warp_buff?
                    gl.bindBuffer gl.ARRAY_BUFFER, warp_buff
                else
                    gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ] # dummy buff
                gl.vertexAttribPointer wab, 3, gl.FLOAT, false, 0, 0
                
                tex = gl.getAttribLocation ps, "tex"
                if tex >= 0
                    gl.enableVertexAttribArray tex
                    gl.bindBuffer gl.ARRAY_BUFFER, data
                    gl.vertexAttribPointer tex, 1, gl.FLOAT, false, 0, 0
                
                col = gl.getUniformLocation ps, "col"
                gl.uniform4f col, 0.7, 0.7, 0.7, 1.0
                
                gl.uniform1f gl.getUniformLocation( ps, "mit" ), legend._min_val.get()
                gl.uniform1f gl.getUniformLocation( ps, "mat" ), legend._max_val.get()
                gl.uniform1f gl.getUniformLocation( ps, "waf" ), warp_factor
                
                info.cam.gl_exec info, "cam", ps
                info.cam.gl_exec_vec info, "can", ps
            
                gl.drawArrays gl.TRIANGLES, 0, 3 * @indices.size( 1 )
                
                gl.disableVertexAttribArray pos
                gl.disableVertexAttribArray nor
                gl.disableVertexAttribArray wab
                gl.disableVertexAttribArray tex                
                
            if display_style in [ "Wireframe", "Surface with Edges" ]
                @_draw_lines info
                
    # the trick of this function is that it use only one linear gradient calculate using point value and position
    draw_nodal_field: ( info, proj, data, display_style, legend ) ->
        if @_get_indices()
    
            # 2D canvas
            max_legend = legend.max_val.get()
            min_legend = legend.min_val.get()
            div_legend = max_legend - min_legend
            div_legend = 1 / ( div_legend + ( div_legend == 0 ) )

            indices = for num_triangle in [ 0 ... @indices.size( 1 ) ]
                [
                    @indices.get [ 0, num_triangle ]
                    @indices.get [ 1, num_triangle ]
                    @indices.get [ 2, num_triangle ]
                ]
            

            indices.sort ( a, b ) -> ( proj[ b[ 0 ] ][ 2 ] + proj[ b[ 1 ] ][ 2 ] + proj[ b[ 2 ] ][ 2 ] ) - ( proj[ a[ 0 ] ][ 2 ] + proj[ a[ 1 ] ][ 2 ] + proj[ a[ 2 ] ][ 2 ] )
            
            for tri in indices
                vals = [
                    data.get tri[ 0 ]
                    data.get tri[ 1 ]
                    data.get tri[ 2 ]
                ]

                for val, i in vals
                    vals[ i ] = ( max_legend - val ) * div_legend
                    
                #             c = max_legend - min_legend + ( max_legend == min_legend )
                #             vals = for i in [ 0 ... 3 ]
                #                 ( data.get( tri[ i ] ) - min_legend ) / c
                
                posit = for i in [ 0 ... 3 ]
                    proj[ tri[ i ] ]
                    
                        
                # position of every point
                x0 = posit[ 0 ][ 0 ]
                y0 = posit[ 0 ][ 1 ]
                
                x1 = posit[ 1 ][ 0 ]
                y1 = posit[ 1 ][ 1 ]
                
                x2 = posit[ 2 ][ 0 ]
                y2 = posit[ 2 ][ 1 ]
                
                mat_pos = [ [ 1, x0, y0 ], [ 1, x1, y1 ], [ 1, x2, y2 ] ]
                det = Vec_3.determinant mat_pos
                det += det == 0
                #             if isNaN det
                #                 console.log proj, tri
                
                mat_a = [ [ vals[ 0 ], x0, y0 ], [ vals[ 1 ], x1, y1 ], [ vals[ 2 ], x2, y2 ] ]
                det_a = Vec_3.determinant mat_a
                a = det_a / det
                            
                mat_b = [ [ 1, vals[ 0 ], y0 ], [ 1, vals[ 1 ], y1 ], [ 1, vals[ 2 ], y2 ] ]
                det_b = Vec_3.determinant mat_b
                b = det_b / det
                
                mat_c = [ [ 1, x0, vals[ 0 ] ], [ 1, x1, vals[ 1 ] ], [ 1, x2, vals[ 2 ] ] ]
                det_c = Vec_3.determinant mat_c
                c = det_c / det
                    
                # getting p0
                if b or c
                    if Math.abs( b ) > Math.abs( c )
                        p0x0 = - a / b
                        p0y0 = 0
                    else
                        p0x0 = 0
                        p0y0 = - a / c
                else
                    p0x0 = 0
                    p0y0 = 0
                    
                p0 = [ p0x0, p0y0, 0 ]
                
                # getting p1
                p1ieqz = ( x ) -> x + ( Math.abs( x ) < 1e-16 )
                alpha = 1 / p1ieqz( b * b + c * c )
                p1 = Vec_3.add( p0, Vec_3.mus( alpha, [ b, c, 0 ] ) )
                #             if isNaN( p0[ 0 ] ) or isNaN( p0[ 1 ] ) or isNaN( p1[ 0 ] ) or isNaN( p1[ 1 ] )
                #                 console.log mat_pos
                #             p0[ 0 ] = Math.min( Math.max( p0[ 0 ], -16000 ), 16000 )
                #             p0[ 1 ] = Math.min( Math.max( p0[ 1 ], -16000 ), 16000 )
                #             p1[ 0 ] = Math.min( Math.max( p1[ 0 ], -16000 ), 16000 )
                #             p1[ 1 ] = Math.min( Math.max( p1[ 1 ], -16000 ), 16000 )
                            
                if display_style == "Surface" or display_style == "Surface with Edges"
                    @_draw_gradient_fill_triangle info, p0, p1, posit, legend
                    
                if display_style == "Surface with Edges" or display_style == "Edges"
                    @_draw_edge_triangle info, posit
                    
                if display_style == "Wireframe"
                    @_draw_gradient_stroke_triangle info, p0, p1, posit, legend
                    
    _draw_lines: ( info ) ->
        vs = "
            precision mediump float;\n
            attribute vec3 pos;\n
            #{ info.cam.gl_attr info, "cam" }\n
            void main( void ) {\n
                gl_Position = vec4( pos, 1.0 );\n
                #{ info.cam.gl_main info, "cam" }\n
                gl_Position -= 1e-5;\n
            }\n
        "
    
        fs = "
            precision mediump float;\n
            uniform vec4 col;\n
            void main( void ) {\n
                gl_FragColor = col;\n
            }\n
        "
        
        ps = info.cm.gl_prog vs, fs # bufferized :)
        
        # draw
        gl = info.ctx
        gl.useProgram ps
        
        pos = gl.getAttribLocation ps, "pos"
        gl.enableVertexAttribArray pos
        gl.bindBuffer gl.ARRAY_BUFFER, @_lns_buffer[ gl.ctx_id ]
        gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
        
        col = gl.getUniformLocation ps, "col"
        #         gl.uniform4f col, 1.0, 1.0, 1.0, 1.0
        
        if @line_color?
            gl.uniform4f col, @line_color.r.get()/255, @line_color.g.get()/255, @line_color.b.get()/255, @line_color.a.get()/255
        else
            gl.uniform4f col, 1.0, 1.0, 1.0, 1.0
        
        info.cam.gl_exec info, "cam", ps
    
        gl.lineWidth 2
        gl.drawArrays gl.LINES, 0, 6 * @indices.size( 1 )
        
        
    _draw_points : ( info ) ->
        vs = "
            precision mediump float;\n
            attribute vec3 pos;\n
            #{ info.cam.gl_attr info, "cam" }\n
            void main( void ) {\n
                gl_Position = vec4( pos, 1.0 );\n
                #{ info.cam.gl_main info, "cam" }\n
                gl_Position -= 1e-5;\n
            }\n
        "
    
        fs = "
            precision mediump float;\n
            uniform vec4 col;\n
            void main( void ) {\n
                gl_FragColor = col;\n
            }\n
        "
        
        ps = info.cm.gl_prog vs, fs # bufferized :)
        
        # draw
        gl = info.ctx
        gl.useProgram ps
        
        pos = gl.getAttribLocation ps, "pos"
        gl.enableVertexAttribArray pos
        gl.bindBuffer gl.ARRAY_BUFFER, @_lns_buffer[0]
        gl.vertexAttribPointer pos, 3, gl.FLOAT, false, 0, 0
        
        col = gl.getUniformLocation ps, "col"
        gl.uniform4f col, 1.0, 1.0, 1.0, 1.0
        
        info.cam.gl_exec info, "cam", ps
    
        gl.lineWidth 2
        gl.drawArrays gl.POINTS, 0, 6 * @indices.size( 1 )
        
    # need to update the arrays ?
    _update_bufs: ( info, mesh, points ) ->
        if @_get_indices()
    
            gl = info.ctx
            if not @_date_pts[ gl.ctx_id ]?
                @_date_pts[ gl.ctx_id ] = -1
            
            if @_date_pts[ gl.ctx_id ] < mesh._date_last_modification
                @_date_pts[ gl.ctx_id ] = mesh._date_last_modification
                
                dim = 3
                cpp = -1
                cpn = -1
                cpl = -1
                pts = new Float32Array 3 * dim * @indices.size( 1 )
                nor = new Float32Array 3 * dim * @indices.size( 1 )
                lns = new Float32Array 6 * dim * @indices.size( 1 )
                for i in [ 0 ... @indices.size( 1 ) ]
                    p0 = mesh.get_point @indices.get([ 0, i ])
                    p1 = mesh.get_point @indices.get([ 1, i ])
                    p2 = mesh.get_point @indices.get([ 2, i ])

                    if ( not p0 or not p1 or not p2 )
                        continue
                    
                    nn = Vec_3.nor( Vec_3.cro( Vec_3.sub( p1, p0 ), Vec_3.sub( p2, p0 ) ) )
                    
                    pts[ cpp += 1 ] = v for v in p0
                    pts[ cpp += 1 ] = v for v in p1
                    pts[ cpp += 1 ] = v for v in p2
                    
                    nor[ cpn += 1 ] = v for v in nn
                    nor[ cpn += 1 ] = v for v in nn
                    nor[ cpn += 1 ] = v for v in nn
                    
                    lns[ cpl += 1 ] = v for v in p0
                    lns[ cpl += 1 ] = v for v in p1
                    lns[ cpl += 1 ] = v for v in p1
                    lns[ cpl += 1 ] = v for v in p2
                    lns[ cpl += 1 ] = v for v in p2
                    lns[ cpl += 1 ] = v for v in p0
                    

                if @_pts_buffer[ gl.ctx_id ]?
                    gl.deleteBuffer @_pts_buffer[ gl.ctx_id ]
                    gl.deleteBuffer @_nor_buffer[ gl.ctx_id ]
                    gl.deleteBuffer @_lns_buffer[ gl.ctx_id ]
                    
                @_pts_buffer[ gl.ctx_id ] = gl.createBuffer()
                gl.bindBuffer gl.ARRAY_BUFFER, @_pts_buffer[ gl.ctx_id ]
                gl.bufferData gl.ARRAY_BUFFER, pts, gl.STATIC_DRAW
                
                @_nor_buffer[ gl.ctx_id ] = gl.createBuffer()
                gl.bindBuffer gl.ARRAY_BUFFER, @_nor_buffer[ gl.ctx_id ]
                gl.bufferData gl.ARRAY_BUFFER, nor, gl.STATIC_DRAW
                
                @_lns_buffer[ gl.ctx_id ] = gl.createBuffer()
                gl.bindBuffer gl.ARRAY_BUFFER, @_lns_buffer[ gl.ctx_id ]
                gl.bufferData gl.ARRAY_BUFFER, lns, gl.STATIC_DRAW

                
    # wireframe. drawing gradient depending p0 and p1 in the correct triangle with the correct color
    _draw_gradient_stroke_triangle: ( info, p0, p1, posit, legend ) ->
        info.ctx.beginPath()
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ], p1[ 0 ], p1[ 1 ]
        for col in legend.color_map.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.strokeStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.stroke()
        
    # drawing gradient depending p0 and p1 in the correct triangle
    _draw_gradient_fill_triangle: ( info, p0, p1, posit, legend ) ->
        info.ctx.beginPath()
        if isNaN( p0[ 0 ] ) or isNaN( p0[ 1 ] ) or isNaN( p1[ 0 ] ) or isNaN( p1[ 1 ] )
            return
        if Math.abs( p0[ 0 ] ) > 1e40 or Math.abs( p0[ 1 ] ) > 1e40 or Math.abs( p1[ 0 ] ) > 1e40 or Math.abs( p1[ 1 ] ) > 1e40
            return
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ], p1[ 0 ], p1[ 1 ]
        for col in legend.color_map.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.strokeStyle = lineargradient
        info.ctx.fillStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
        
        
    draw_elementary_triangle: ( info, proj, data, display_style, legend ) ->
        max_legend = legend.max_val.get()
        min_legend = legend.min_val.get()
        div_legend = max_legend - min_legend
        div_legend = 1 / ( div_legend + ( div_legend == 0 ) )
        for num_triangle in [ 0 ... @indices.size( 1 ) ]
            tri = [
                @indices.get [ 0, num_triangle ]
                @indices.get [ 1, num_triangle ]
                @indices.get [ 2, num_triangle ]
            ]
                    
            value = data.get num_triangle

            position = for i in [ 0 ... 3 ]
                proj[ tri[ i ] ]
    
    
            pos = ( max_legend - value ) / ( max_legend - min_legend )
            col = legend.color_map.get_color_from_pos pos
    
            if info.ctx_type == "2d"
                if display_style == "Wireframe"
                    @_draw_elementary_stroke_triangle info, position, col
                if display_style == "Surface" or display_style == "Surface with Edges"
                    @_draw_elementary_fill_triangle info, position, col
                if display_style == "Surface with Edges" or display_style == "Edges"
                    @_draw_edge_triangle info, position
            else
                if not @_sf?
                    @_sf = new SurfaceTheme
                    
                p0 = ( x for x in position[ 0 ] )
                p1 = ( x for x in position[ 1 ] )
                p2 = ( x for x in position[ 2 ] )
                p0[ 2 ] *= Math.max info.w, info.h
                p1[ 2 ] *= Math.max info.w, info.h
                p2[ 2 ] *= Math.max info.w, info.h
                nor = Vec_3.nor( Vec_3.cro( Vec_3.sub( p1, p0 ), Vec_3.sub( p2, p0 ) ) )
                gv = 0.5 + 0.4 * Math.abs( nor[ 2 ] )
                    
                @_sf.draw_triangle info, position[ 0 ], position[ 1 ], position[ 2 ], ( gv * c / 255.0 for c in col )
          
        
    # draw edges of triangle with adapted color
    _draw_elementary_stroke_triangle: ( info, position, col ) ->
        info.ctx.beginPath()        
        info.ctx.strokeStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.stroke()        
        info.ctx.closePath()
        
    # draw surface of triangle
    _draw_elementary_fill_triangle: ( info, position, col ) ->
        info.ctx.beginPath()
        info.ctx.fillStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.strokeStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
        info.ctx.closePath()
        
    # draw edges of triangle as normal lines
    _draw_edge_triangle: ( info, posit ) ->
        info.theme.lines.beg_ctx info
        info.theme.lines.draw_straight_proj info, posit[ 0 ], posit[ 1 ]
        info.theme.lines.draw_straight_proj info, posit[ 1 ], posit[ 2 ]
        info.theme.lines.draw_straight_proj info, posit[ 2 ], posit[ 0 ]
        info.theme.lines.end_ctx info

    _get_indices: () ->
        return @indices