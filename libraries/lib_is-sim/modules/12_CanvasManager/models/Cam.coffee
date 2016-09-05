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



# camera
class Cam extends Model 
    constructor: ( want_aspect_ratio = false ) ->
        super()

        # default values
        @add_attr
            threeD: true # if false, only 2D movements are allowed
            O: [ 0, 0, 0 ]
            X: [ 1, 0, 0 ]
            Y: [ 0, 1, 0 ]
            C: [ 0, 0, 0 ] # rotation center
            d: 1  # viewable diameter
            _O: [ 0, 0, 0 ]
            _d: 1
            a: new ConstrainedVal( 20,
                min: 0
                max: 80
            ) # perspective angle
        if want_aspect_ratio
            @add_attr
               r: 1
               
    gl_mat: ( w, h ) ->
        #bb = info.cm.bounding_box()
        #xmin = bb[ 0 ]
        #xmax = bb[ 1 ]
        
        # normalization
        X = Vec_3.nor @X.get()
        Y = Vec_3.nor Vec_3.sub( @Y.get(), Vec_3.mus( Vec_3.dot( X, @Y.get() ), X ) )
        Z = Vec_3.nor Vec_3.cro Y, X    # <- inverted to have a right-handed coord system
        O = [ Vec_3.dot( @O.get(), X ), Vec_3.dot( @O.get(), Y ), Vec_3.dot( @O.get(), Z ) ]
        f = 2 / @d.get() # * ( 1.0 + p *  ) )
        g = -f
        
        cx = Math.min( w, h ) / w
        cy = Math.min( w, h ) / h

        #
        O_w = @_O.get()
        d_w = @_d.get()
        
        # Z
        p = Math.tan( @a.get() * 3.14158 / 360 ) * 2 / d_w
        z_max = Vec_3.dot( O_w, Z ) + d_w / 2
        z_min = Vec_3.dot( O_w, Z ) - d_w / 2
        #         if p
        #             eps = 1e-6
        #             z_min = Math.max( 
        #                 eps * z_max + ( 1 - eps ) * ( p * Vec_3.dot( @O.get(), Z ) - 1 ) / p,
        #                 z_min
        #             )
        # h = ( 2.0 * ( 1.0 - p * Vec_3.dot( O, Z ) ) + p * ( z_max + z_min ) ) / ( z_max - z_min )
        # i = ( h * ( z_max + z_min ) - p * ( z_max - z_min ) ) / 2.0
        h = 1.0 / ( z_max - z_min )
        i = 0.5 * ( z_min + z_max ) / ( z_max - z_min )
        [
              cx * f * X[ 0 ],   cy * f * Y[ 0 ],   h * Z[ 0 ],     p * Z[ 0 ],
              cx * f * X[ 1 ],   cy * f * Y[ 1 ],   h * Z[ 1 ],     p * Z[ 1 ],
              cx * f * X[ 2 ],   cy * f * Y[ 2 ],   h * Z[ 2 ],     p * Z[ 2 ],         # remove all the "-" at this line to have a left-handed coordinates system
              cx * g * O[ 0 ],   cy * g * O[ 1 ],          - i, 1 - p * O[ 2 ]
        ]
    
               
    gl_attr: ( info, prefix ) ->
        "uniform mat4 #{prefix}_mat;"
               
    gl_attr_vec: ( info, prefix ) ->
        "uniform mat3 #{prefix}_mat;"

    gl_main: ( info, prefix ) ->
        "gl_Position = #{prefix}_mat * gl_Position;"
        
    gl_main_vec: ( info, prefix, norm_val, norm_var ) ->
        "#{ norm_var } = #{ prefix }_mat * #{ norm_val };"

    gl_exec: ( info, prefix, prog ) ->
        mat = @gl_mat info.w, info.h

        gl = info.ctx
        proj_mat = gl.getUniformLocation prog, "#{prefix}_mat"
        gl.uniformMatrix4fv proj_mat, false, new Float32Array mat

    gl_exec_vec: ( info, prefix, prog ) ->
        X = Vec_3.nor @X.get()
        Y = Vec_3.nor Vec_3.sub( @Y.get(), Vec_3.mus( Vec_3.dot( X, @Y.get() ), X ) )
        Z = Vec_3.nor Vec_3.cro X, Y
        
        mat = [
            X[ 0 ], Y[ 0 ], Z[ 0 ],
            X[ 1 ], Y[ 1 ], Z[ 1 ],
            X[ 2 ], Y[ 2 ], Z[ 2 ]
        ]

        gl = info.ctx
        proj_mat = gl.getUniformLocation prog, "#{prefix}_mat"
        gl.uniformMatrix3fv proj_mat, false, new Float32Array mat

    # bad name
    focal_point: ->
        nZ = Vec_3.nor Vec_3.cro @X.get(), @Y.get()
        ap = Math.tan( @a.get() / 2 * 3.14159265358979323846 / 180 )
        [
            @O[ 0 ].get() - 0.5 * @d.get() / ap * nZ[ 0 ],
            @O[ 1 ].get() - 0.5 * @d.get() / ap * nZ[ 1 ],
            @O[ 2 ].get() - 0.5 * @d.get() / ap * nZ[ 2 ]
        ]
               
    # translate screen
    pan: ( x, y, w, h, ctrl_key = false ) ->
        if ctrl_key
            x /= 10
            y /= 10
        c = @d.get() / Math.min( w, h )
        r = @r or 1
        x *= c * r
        y *= c
        for d in [ 0 .. 2 ]
            @O[ d ].set @O[ d ].get() - x * @X[ d ].get() + y * @Y[ d ].get()

    # c may be a number or a vector of size 2
    zoom: ( x, y, c, w, h ) ->
        if typeof( c ) == "number"
            zoom x, y, [ c, c ], w, h
        else
            o_sc_2_rw = @sc_2_rw w, h
            o = o_sc_2_rw.pos x, y
            
            @d.set @d.get() / c[ 1 ]
            if @r?
                @r.set @r.get() * c[ 1 ] / c[ 0 ]

            n_re_2_sc = @re_2_sc w, h
            p = n_re_2_sc.proj o
            
            @pan x - p[ 0 ], y - p[ 1 ], w, h

    # around @C
    rotate: ( x, y, z ) ->
        if @threeD.get()
            R = @s_to_w_vec [ -x, -y, z ]
            @X.set Vec_3.rot @X.get(), R
            @Y.set Vec_3.rot @Y.get(), R
            @O.set Vec_3.add( @C.get(), Vec_3.rot( Vec_3.sub( @O.get(), @C.get() ), R ) )
            
    re_2_sc: ( w, h ) -> # real to screen coordinates
        new TransBuf @gl_mat( w, h ), w, h
    
    sc_2_rw: ( w, h ) -> # screen to real coordinates
        new TransEye @gl_mat( w, h ), w, h

    equal: ( l ) ->
        ap_3 = ( a, b, e = 1e-3 ) -> 
            Math.abs( a[ 0 ] - b[ 0 ] ) < e and Math.abs( a[ 1 ] - b[ 1 ] ) < e and Math.abs( a[ 2 ] - b[ 2 ] ) < e
            
        if @r? and l.r? and l.r.get() != @r.get()
            return false
        return l.w == @w and l.h == @h and ap_3( l.O, @O ) and ap_3( l.X, @X ) and ap_3( l.Y, @Y ) and Math.abs( l.a - @a ) < 1e-3 and Math.abs( l.d - @d ) / @d < 1e-3

    s_to_w_vec: ( V ) -> # screen orientation to real world.
        X = Vec_3.nor @X.get()
        Y = Vec_3.nor @Y.get()
        Z = Vec_3.nor Vec_3.cro X, Y
        return [
            V[ 0 ] * @X[ 0 ] + V[ 1 ] * @Y[ 0 ] + V[ 2 ] * Z[ 0 ],
            V[ 0 ] * @X[ 1 ] + V[ 1 ] * @Y[ 1 ] + V[ 2 ] * Z[ 1 ],
            V[ 0 ] * @X[ 2 ] + V[ 1 ] * @Y[ 2 ] + V[ 2 ] * Z[ 2 ]
        ]

    get_X: ->
        Vec_3.nor @X.get()

    get_Y: ->
        Vec_3.nor @Y.get()
        
    get_Z: ->
        Vec_3.nor Vec_3.cro @X.get(), @Y.get()
        
    get_a: ->
        @a.get()
        
    # return coordinates depending the current cam state from real coordinates
    get_screen_coord : ( coord ) ->
        x = coord[ 0 ]
        y = coord[ 1 ]
        z = coord[ 2 ] or 0
        
        O = @O.get()
        X = @X.get()
        Y = @Y.get()
        Z = @get_Z()
        d = @d
        Cx = Vec_3.mus d * x, X
        Cy = Vec_3.mus d * y, Y
        Cz = Vec_3.mus d * z, Z
        return Vec_3.add O, Vec_3.add Cx, Vec_3.add Cy, Cz
    
    class TransEye # screen -> eye dir and pos
        constructor: ( @mat, @w, @h ) ->
            
        dir: ( x, y ) ->
            Vec_3.nor Vec_3.sub( Vec_3.solve( @mat, [ x, y, 0.5, 1 ] ), Vec_3.solve( @mat, [ x, y, -0.5, 1 ] ) )

        pos: ( x, y, z = 0 ) -> 
            R = Vec_3.solve @mat, [ 2 * x / @w - 1, 1 - 2 * y / @h, z, 1 ]
            [ R[ 0 ] / R[ 3 ], R[ 1 ] / R[ 3 ], R[ 2 ] / R[ 3 ] ]

    class TransBuf # real pos -> screen
        constructor: ( @mat, @w, @h ) ->
            
        proj: ( P ) ->
            R = [
                @mat[ 0 + 4 * 0 ] * P[ 0 ] + @mat[ 0 + 4 * 1 ] * P[ 1 ] + @mat[ 0 + 4 * 2 ] * P[ 2 ] + @mat[ 0 + 4 * 3 ]
                @mat[ 1 + 4 * 0 ] * P[ 0 ] + @mat[ 1 + 4 * 1 ] * P[ 1 ] + @mat[ 1 + 4 * 2 ] * P[ 2 ] + @mat[ 1 + 4 * 3 ]
                @mat[ 2 + 4 * 0 ] * P[ 0 ] + @mat[ 2 + 4 * 1 ] * P[ 1 ] + @mat[ 2 + 4 * 2 ] * P[ 2 ] + @mat[ 2 + 4 * 3 ]
                @mat[ 3 + 4 * 0 ] * P[ 0 ] + @mat[ 3 + 4 * 1 ] * P[ 1 ] + @mat[ 3 + 4 * 2 ] * P[ 2 ] + @mat[ 3 + 4 * 3 ]
            ]
            return [ 0.5 * @w * ( 1 + R[ 0 ] / R[ 3 ] ), 0.5 * @h * ( 1 - R[ 1 ] / R[ 3 ] ), R[ 2 ] / R[ 3 ] ]
        