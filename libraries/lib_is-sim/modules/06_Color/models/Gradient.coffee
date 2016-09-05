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



class Gradient extends Model
    constructor: ( predef ) ->
        super()
        
        
        @add_attr
            color_stop : []
            
        if predef == "b2w"
            @add_color [ 255,   0,   0, 255 ], 0
            @add_color [   0, 255,   0, 255 ], 0
            @add_color [   0,   0, 255, 255 ], 1
    
    add_color: ( color = [ 0, 0, 0, 255 ], position = 0 ) ->
        @color_stop.push
            color: new Color color[ 0 ], color[ 1 ], color[ 2 ], color[ 3 ]
            position: position
            
    remove_color: ( position ) ->
        @color_stop.splice position, 1
        
    get_fragment_shader: ( v, m = "", n = "" ) ->
        dc = for col in @color_stop
            [ col.position.get(), col.color.r.get() / 255.0, col.color.g.get() / 255.0, col.color.b.get() / 255.0, col.color.a.get() / 255.0 ]
        dc.sort ( a, b ) -> a[ 0 ] - b[ 0 ]
        
        fs  = "precision mediump float;"
        fs += "varying float #{v};"
        if n.length
            fs += "varying vec3 #{ n };"
        if m.length
            fs += "uniform vec4 #{ m };"
        fs += "void main( void ) {"
        
        if n.length
            fs += "    float cm = abs( #{ n }[ 2 ] );"
        else
            fs += "    float cm = 1.0;"
        
        for col in [ 1 ... dc.length ]
            if m.length
                fs += "
                    if ( #{v} <= float( #{ dc[ col - 0 ][ 0 ] } ) ) {\n
                        vec4 c1 = vec4( #{ m }.r * float( #{ dc[ col - 0 ][ 1 ] } ), #{ m }.g * float( #{ dc[ col - 0 ][ 2 ] } ), #{ m }.b * float( #{ dc[ col - 0 ][ 3 ] } ), #{ m }.a * float( #{ dc[ col - 0 ][ 4 ] } ) );\n
                        vec4 c0 = vec4( #{ m }.r * float( #{ dc[ col - 1 ][ 1 ] } ), #{ m }.g * float( #{ dc[ col - 1 ][ 2 ] } ), #{ m }.b * float( #{ dc[ col - 1 ][ 3 ] } ), #{ m }.a * float( #{ dc[ col - 1 ][ 4 ] } ) );\n
                        gl_FragColor = c0 + ( c1 - c0 ) * ( #{v} - float( #{ dc[ col - 1 ][ 0 ] } ) ) / ( float( #{ dc[ col - 0 ][ 0 ] } ) - float( #{ dc[ col - 1 ][ 0 ] } ) );\n
                        gl_FragColor.r *= cm; gl_FragColor.g *= cm; gl_FragColor.b *= cm;\n
                        return;\n
                    }\n
                "
            else
                fs += "
                    if ( #{v} <= float( #{ dc[ col - 0 ][ 0 ] } ) ) {\n
                        vec4 c0 = vec4( #{ dc[ col - 1 ][ 1 ] }, #{ dc[ col - 1 ][ 2 ] }, #{ dc[ col - 1 ][ 3 ] }, #{ dc[ col - 1 ][ 4 ] } );\n
                        vec4 c1 = vec4( #{ dc[ col - 0 ][ 1 ] }, #{ dc[ col - 0 ][ 2 ] }, #{ dc[ col - 0 ][ 3 ] }, #{ dc[ col - 0 ][ 4 ] } );\n
                        gl_FragColor = c0 + ( c1 - c0 ) * ( #{v} - float( #{ dc[ col - 1 ][ 0 ] } ) ) / ( float( #{ dc[ col - 0 ][ 0 ] } ) - float( #{ dc[ col - 1 ][ 0 ] } ) );\n
                        gl_FragColor.r *= cm; gl_FragColor.g *= cm; gl_FragColor.b *= cm;\n
                        return;\n
                    }\n
                "
            
        fs + "
                gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );\n
            }\n
        "
        
        
    get_color_from_pos: ( position ) ->
    
#         for c in @color_stop
#             console.log c.position.get()
# 
#         # First program determine in between which color_stop position is
#         @color_stop.sort ( a, b ) ->
#             return b.position.get() - a.position.get()
# 
#         for c in @color_stop
#             console.log c.position.get()

        
        ind_color_stop = []
        for c, i in @color_stop
            if c.position.get() >= position
                # return first color
                if i == 0
                    return [ @color_stop[ 0 ].color.r.get(), @color_stop[ 0 ].color.g.get(), @color_stop[ 0 ].color.b.get(), @color_stop[ 0 ].color.a.get() ]
                else #normal case
                    ind_color_stop.push i-1
                    ind_color_stop.push i
                break
                
        # return last color
        if ind_color_stop.length == 0
            last_ind = @color_stop.length - 1
            return [ @color_stop[ last_ind ].color.r.get(), @color_stop[ last_ind ].color.g.get(), @color_stop[ last_ind ].color.b.get(), @color_stop[ last_ind ].color.a.get() ]

        # Interpolation between two color_stop depending position
        size_of_interval = Math.abs @color_stop[ ind_color_stop[ 1 ] ].position.get() - @color_stop[ ind_color_stop[ 0 ] ].position.get()
        size_of_new_interval = Math.abs @color_stop[ ind_color_stop[ 0 ] ].position.get() - position
        factor = size_of_interval / size_of_new_interval
        
        col_r = @color_stop[ ind_color_stop[ 0 ] ].color.r.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.r.get() - @color_stop[ ind_color_stop[ 0 ] ].color.r.get() ) ) / factor
        col_g = @color_stop[ ind_color_stop[ 0 ] ].color.g.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.g.get() - @color_stop[ ind_color_stop[ 0 ] ].color.g.get() ) ) / factor
        col_b = @color_stop[ ind_color_stop[ 0 ] ].color.b.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.b.get() - @color_stop[ ind_color_stop[ 0 ] ].color.b.get() ) ) / factor
        col_a = @color_stop[ ind_color_stop[ 0 ] ].color.a.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.a.get() - @color_stop[ ind_color_stop[ 0 ] ].color.a.get() ) ) / factor

        return [ col_r, col_g, col_b, col_a ]