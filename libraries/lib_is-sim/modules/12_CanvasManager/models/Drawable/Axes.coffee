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



# #
class Axes extends Drawable
    constructor: ->
        super()
        
        @add_attr
            p: new Choice( 0, [ "lb", "lt", "rb", "rt", "mm" ] ) # position in the screen. lb = left bottom...
            r: new ConstrainedVal( 0.05, { min: 0, max: 1 } ) # size of the box, expressed as ratio of the screen size 
            d: 1 # "real" diameter of axes. Used only if @p == "mm" (middle middle)
            l: new ConstrainedVal( 2, { min: 0, max: 10, div: 10 } ) # line width

        @red = new Color( 255, 0, 0 )
        @green = new Color( 0, 255, 0 )
        @blue = new Color( 0, 0, 255 )
        @theme_x = new LineTheme( @red )
        @theme_y = new LineTheme( @green )
        @theme_z = new LineTheme( @blue )
        
    z_index: ->
        return 10000
        
    draw: ( info ) ->
        [ o, x, y, z ] = @_coords info
        vz = -1 + 1e-5
        o[ 2 ] = vz
        x[ 2 ] = vz
        y[ 2 ] = vz
        z[ 2 ] = vz

        @theme_x.beg_ctx info
        @theme_x.draw_straight_proj info, o, x
        @theme_x.end_ctx info
        
        @theme_y.beg_ctx info
        @theme_y.draw_straight_proj info, o, y
        @theme_y.end_ctx info
        
        @theme_z.beg_ctx info
        @theme_z.draw_straight_proj info, o, z
        @theme_z.end_ctx info
        
        info.cm.fillText "X", x[ 0 ] + 0.5*(x[0]-o[0]), x[ 1 ] + 0.5*(x[1]-o[1]), "14px monospace", "center", @red.to_rgba() 
        info.cm.fillText "Y", y[ 0 ] + 0.5*(y[0]-o[0]), y[ 1 ] + 0.5*(y[1]-o[1]), "14px monospace", "center", @green.to_rgba()
        info.cm.fillText "Z", z[ 0 ] + 0.5*(z[0]-o[0]), z[ 1 ] + 0.5*(z[1]-o[1]), "14px monospace", "center", @blue.to_rgba()

        
    _coords: ( info ) ->
        d = @d.get()
        if d < 0 or not @p.equals( "mm" )
            d = info.cam.d.get() / 10
        
        l = @r.get() * ( if @_fixed() then d else info.cam.d.get() )
        s = 1.0 * info.mwh * @r.get()
        c = info.cam.O.get()
        
        o = info.re_2_sc.proj Vec_3.add c, [ 0, 0, 0 ]
        x = info.re_2_sc.proj Vec_3.add c, [ l, 0, 0 ]
        y = info.re_2_sc.proj Vec_3.add c, [ 0, l, 0 ]
        z = info.re_2_sc.proj Vec_3.add c, [ 0, 0, l ]
        
        mi_x = Math.min o[ 0 ], x[ 0 ], y[ 0 ], z[ 0 ]
        ma_x = Math.max o[ 0 ], x[ 0 ], y[ 0 ], z[ 0 ]
        mi_y = Math.min o[ 1 ], x[ 1 ], y[ 1 ], z[ 1 ]
        ma_y = Math.max o[ 1 ], x[ 1 ], y[ 1 ], z[ 1 ]

        #
        p = @p.get()
        
        if p[ 0 ] == "l" or p[ 0 ] == "r"
            dec = if p[ 0 ] == "r" then info.w - ma_x - s else s - mi_x
            x[ 0 ] += dec
            y[ 0 ] += dec
            z[ 0 ] += dec
            o[ 0 ] += dec
            
        if p[ 1 ] == "b" or p[ 1 ] == "t"
            dec = if p[ 1 ] == "b" then info.h - ma_y - s else s - mi_y
            x[ 1 ] += dec
            y[ 1 ] += dec
            z[ 1 ] += dec
            o[ 1 ] += dec
        
        return [ o, x, y, z ]

    _fixed: () ->
        @p.equals "mm"
