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
class ViewItem extends TreeItem
    constructor: ( @app_data, panel_id, cam = new( Cam ) ) ->
        super()
        
        # attributes
        @add_attr
            background: new Background
            cam       : cam
            axes      : new Axes
            _panel_id : panel_id
            _repr     : ""
            
        @_buff = new Image
        @_buff.onload = =>
            @_signal_change()
            
        @bind =>
            if @_repr? and @_repr.has_been_modified()
                @_buff.src = @_repr.get()
        
        # default values
        @_name.set "View"
        
        @_date_tex = -1
        
    accept_child: ( ch ) ->
        #

    z_index: ->
        1
        
    draw: ( info ) ->
        # draw images computed by the server
        if info.ctx_type == '2d'
            info.ctx.drawImage @_buff, 0, 0
        else
            if @_buff.width
                vs = "
                    attribute vec3 a_position;\n
                    attribute vec2 textureCoords;\n
                    varying vec2 texcoords;\n
                    void main( void ) {\n
                        texcoords = textureCoords;\n
                        gl_Position = vec4( a_position, 1.0 );\n
                    }\n
                "            
                
                fs = "
                    precision mediump float;\n
                    varying vec2 texcoords;\n
                    uniform sampler2D uSampler;\n
                    void main( void ) {\n
                        gl_FragColor = texture2D( uSampler, texcoords );\n
                    }\n
                ";

                gl = info.ctx
                ps = info.cm.gl_prog vs, fs # bufferized :)
                gl.useProgram ps
                
                ps.atexAttrib = gl.getAttribLocation ps, "textureCoords"
                ps.aposAttrib = gl.getAttribLocation ps, "a_position"
                # gl.enableVertexAttribArray ps.aposAttrib
                # gl.enableVertexAttribArray ps.atexAttrib

                if @_date_tex < @_repr._date_last_modification
                    @_date_tex = @_repr._date_last_modification
                    if @tex?
                        gl.deleteTexture @tex
        
                    @tex = gl.createTexture()
                    gl.activeTexture gl.TEXTURE0
                    gl.bindTexture gl.TEXTURE_2D, @tex
                    gl.pixelStorei gl.UNPACK_FLIP_Y_WEBGL, true
                    gl.texImage2D gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, @_buff
                    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST
                    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST
                    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE
                    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE

                gl.bindTexture gl.TEXTURE_2D, @tex
                ps.samplerUniform = gl.getUniformLocation ps, "uSampler"
                gl.uniform1i ps.samplerUniform, 0

                z = 1.0 - 1e-5
                vtx = new Float32Array [
                    -1.0, -1.0, z
                     1.0,  1.0, z,
                     1.0, -1.0, z,
                    -1.0,  1.0, z,
                ]
                
                txc = new Float32Array [
                    0, 0,
                    1, 1,
                    1, 0,
                    0, 1
                ]
                idx = new Uint16Array [
                    0, 2, 3, 1
                ]
                initBuffer = ( glELEMENT_ARRAY_BUFFER, data ) ->
                    buf = gl.createBuffer()
                    gl.bindBuffer glELEMENT_ARRAY_BUFFER, buf
                    gl.bufferData glELEMENT_ARRAY_BUFFER, data, gl.STATIC_DRAW
                    buf
                vbuf = initBuffer gl.ARRAY_BUFFER, vtx
                ibuf = initBuffer gl.ELEMENT_ARRAY_BUFFER, idx
                gl.vertexAttribPointer ps.aposAttrib, 3, gl.FLOAT, false, 0, 0
                gl.enableVertexAttribArray ps.aposAttrib
                
                tbuf = initBuffer gl.ARRAY_BUFFER, txc
                gl.vertexAttribPointer ps.atexAttrib, 2, gl.FLOAT, false, 0, 0
                gl.enableVertexAttribArray ps.atexAttrib
                                        
                gl.drawElements gl.TRIANGLE_STRIP, 4, gl.UNSIGNED_SHORT, 0

                gl.disableVertexAttribArray ps.aposAttrib
                gl.disableVertexAttribArray ps.atexAttrib

                gl.bindBuffer gl.ARRAY_BUFFER, null
                gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, null
                gl.bindTexture gl.TEXTURE_2D, null
                
                gl.deleteBuffer tbuf
                gl.deleteBuffer ibuf
                gl.deleteBuffer vbuf
        
    sub_canvas_items: ->
        [ @background, @axes ]

    #     has_nothing_to_draw: ->
    #         true
