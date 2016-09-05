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
class Element_Q4List extends Element
    constructor: ->
        super()
        
        @add_attr
            indices: new TypedArray_Int32 [ 4, 0 ]
            
        @_date_pts = {}
        @_pts_buffer = {}
        @_nor_buffer = {}
        @_lns_buffer = {}
                  
        @bind =>
            if @indices.has_been_modified()
                @indices_tri = @_convert_quad_to_tri @indices
     
    # conversion des indices des éléments Q4 en indices d'éléments T3 (webgl ne construit que des éléments triangle)
    _convert_quad_to_tri: ( indices ) ->
        indices_tri = new TypedArray_Int32 [ 3, 2*indices._size[1] ]
        for i in [0..(indices._data.length / 4)-1 ]
            indice_q1 = indices._data[4*i]
            indice_q2 = indices._data[4*i+1]
            indice_q3 = indices._data[4*i+2]
            indice_q4 = indices._data[4*i+3]
            indices_tri._data[6*i] = indice_q1
            indices_tri._data[6*i+1] = indice_q2
            indices_tri._data[6*i+2] = indice_q3
            indices_tri._data[6*i+3] = indice_q1
            indices_tri._data[6*i+4] = indice_q3
            indices_tri._data[6*i+5] = indice_q4
        return indices_tri            
   
   
    # fonction qui récupère les indices convertis
    _get_indices: () ->
        if not @indices_tri
            @indices_tri = @_convert_quad_to_tri @indices
        
        return @indices_tri     
   
            
    draw_gl: ( info, mesh, points, is_a_sub ) ->
        if @_get_indices()
        
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
                    gl.drawArrays gl.TRIANGLES, 0, 3 * @_get_indices().size( 1 )
                    #gl.drawArrays gl.GL_TRIANGLES_ADJACENCY, 0, 3 * @indices.size( 1 )
                    
                    #             console.log gl.getError()
                
                
            if mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
                @_update_bufs_lines info, mesh, points
                gl = info.ctx   
                @_draw_lines info

            if mesh.visualization.display_style.get() in [ "Points" ]
                @_draw_points info


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

                gl.drawArrays gl.TRIANGLES, 0, 3 * @_get_indices().size( 1 )
                
                gl.disableVertexAttribArray pos
                gl.disableVertexAttribArray nor
                gl.disableVertexAttribArray wab
                gl.disableVertexAttribArray tex
                
            if display_style in [ "Wireframe", "Surface with Edges" ]
                @_update_bufs_lines info, mesh, points
                gl = info.ctx   
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
            
                gl.drawArrays gl.TRIANGLES, 0, 3 * @_get_indices().size( 1 )
                
                gl.disableVertexAttribArray pos
                gl.disableVertexAttribArray nor
                gl.disableVertexAttribArray wab
                gl.disableVertexAttribArray tex
                
            if display_style in [ "Wireframe", "Surface with Edges" ]
                @_update_bufs_lines info, mesh, points
                gl = info.ctx   
                @_draw_lines info

                    
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
        gl.drawArrays gl.LINES, 0, 8 * @indices.size( 1 )

        
        
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
        gl.drawArrays gl.POINTS, 0, 6 * @_get_indices().size( 1 )
        
        
    # need to update the arrays ?
    _update_bufs: ( info, mesh, points ) ->
        if @_get_indices()?
            gl = info.ctx
            if not @_date_pts[ gl.ctx_id ]?
                @_date_pts[ gl.ctx_id ] = -1
            
            if @_date_pts[ gl.ctx_id ] < mesh._date_last_modification
                @_date_pts[ gl.ctx_id ] = mesh._date_last_modification
                
                dim = 3
                cpp = -1
                cpn = -1
                cpl = -1
                pts = new Float32Array 3 * dim * @_get_indices().size( 1 )
                nor = new Float32Array 3 * dim * @_get_indices().size( 1 )
                lns = new Float32Array 6 * dim * @_get_indices().size( 1 )
                for i in [ 0 ... @_get_indices().size( 1 ) ]
                    p0 = mesh.get_point @_get_indices().get([ 0, i ])
                    p1 = mesh.get_point @_get_indices().get([ 1, i ])
                    p2 = mesh.get_point @_get_indices().get([ 2, i ])
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



    _update_bufs_lines: ( info, mesh, points ) ->
        if @_get_indices()
            gl = info.ctx
            
            dim = 3
            cpp = -1
            cpn = -1
            cpl = -1
            pts = new Float32Array 4 * dim * @indices.size( 1 )
            nor = new Float32Array 4 * dim * @indices.size( 1 )
            lns = new Float32Array 8 * dim * @indices.size( 1 )
            for i in [ 0 ... @indices.size( 1 ) ]
                p0 = mesh.get_point @indices.get([ 0, i ])
                p1 = mesh.get_point @indices.get([ 1, i ])
                p2 = mesh.get_point @indices.get([ 2, i ])
                p3 = mesh.get_point @indices.get([ 3, i ])
                if ( not p0 or not p1 or not p2 or not p3 )
                    continue                
                
                nn = Vec_3.nor( Vec_3.cro( Vec_3.sub( p1, p0 ), Vec_3.sub( p2, p0 ) ) )
                
                pts[ cpp += 1 ] = v for v in p0
                pts[ cpp += 1 ] = v for v in p1
                pts[ cpp += 1 ] = v for v in p2
                pts[ cpp += 1 ] = v for v in p3
                
                nor[ cpn += 1 ] = v for v in nn
                nor[ cpn += 1 ] = v for v in nn
                nor[ cpn += 1 ] = v for v in nn
                
                lns[ cpl += 1 ] = v for v in p0
                lns[ cpl += 1 ] = v for v in p1
                lns[ cpl += 1 ] = v for v in p1
                lns[ cpl += 1 ] = v for v in p2
                lns[ cpl += 1 ] = v for v in p2
                lns[ cpl += 1 ] = v for v in p3
                lns[ cpl += 1 ] = v for v in p3
                lns[ cpl += 1 ] = v for v in p0
                

            gl.deleteBuffer @_lns_buffer[ gl.ctx_id ]          
            
            @_lns_buffer[ gl.ctx_id ] = gl.createBuffer()
            gl.bindBuffer gl.ARRAY_BUFFER, @_lns_buffer[ gl.ctx_id ]
            gl.bufferData gl.ARRAY_BUFFER, lns, gl.STATIC_DRAW               



            
