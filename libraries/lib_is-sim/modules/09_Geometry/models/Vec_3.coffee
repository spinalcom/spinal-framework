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



# a Vec of fixed size = 3
class Vec_3 extends Vec
    static_length: ->
        3

    @sub: ( a, b ) ->
        return [ a[ 0 ] - b[ 0 ], a[ 1 ] - b[ 1 ], a[ 2 ] - b[ 2 ] ]

    @add: ( a, b ) ->
        return [ a[ 0 ] + b[ 0 ], a[ 1 ] + b[ 1 ], a[ 2 ] + b[ 2 ] ]
        
    @mul: ( a, b ) ->
        return [ a[ 0 ] * b[ 0 ], a[ 1 ] * b[ 1 ], a[ 2 ] * b[ 2 ] ]
        
    @div: ( a, b ) ->
        return [ a[ 0 ] / b[ 0 ], a[ 1 ] / b[ 1 ], a[ 2 ] / b[ 2 ] ]

    @mus: ( a, b ) -> # mul by scalar
        return [ a * b[ 0 ], a * b[ 1 ], a * b[ 2 ] ]

    @dis: ( a, b ) -> # div by scalar
        return [ a[ 0 ] / b, a[ 1 ] / b, a[ 2 ] / b ]
        
    @ads: ( a, b ) -> # add a scalar
        return [ a + b[ 0 ], a + b[ 1 ], a + b[ 2 ] ]

    @dot: ( a, b ) ->
        return a[ 0 ] * b[ 0 ] + a[ 1 ] * b[ 1 ] + a[ 2 ] * b[ 2 ]

    # vectorial product
    @cro: ( a, b ) ->
        return [ a[ 1 ] * b[ 2 ] - a[ 2 ] * b[ 1 ], a[ 2 ] * b[ 0 ] - a[ 0 ] * b[ 2 ], a[ 0 ] * b[ 1 ] - a[ 1 ] * b[ 0 ] ]

    @min: ( a ) ->
        return [ -a[ 0 ], -a[ 1 ], -a[ 2 ] ]

    # length
    @len: ( a ) ->
        return Math.sqrt( a[ 0 ] * a[ 0 ] + a[ 1 ] * a[ 1 ] + a[ 2 ] * a[ 2 ] )

    # normalized vector
    @nor: ( a ) ->
        l = Vec_3.len( a ) + 1e-40
        return [ a[ 0 ] / l, a[ 1 ] / l, a[ 2 ] / l ]
        
    @dist: ( a, b ) ->
        return Math.sqrt( ( Math.pow (a[ 0 ] - b[ 0 ]), 2 ) + ( Math.pow (a[ 1 ] - b[ 1 ]), 2 ) + ( Math.pow (a[ 2 ] - b[ 2 ]), 2 ) )
 
    # equal
    @equ: ( a, b ) ->
        return a[ 0 ] == b[ 0 ] and a[ 1 ] == b[ 1 ] and a[ 2 ] == b[ 2 ]

    @rot: ( V, R ) ->
        a = Vec_3.len( R ) + 1e-40
        x = R[ 0 ] / a
        y = R[ 1 ] / a
        z = R[ 2 ] / a
        c = Math.cos( a )
        s = Math.sin( a )
        return [
            ( x*x+(1-x*x)*c ) * V[ 0 ] + ( x*y*(1-c)-z*s ) * V[ 1 ] + ( x*z*(1-c)+y*s ) * V[ 2 ],
            ( y*x*(1-c)+z*s ) * V[ 0 ] + ( y*y+(1-y*y)*c ) * V[ 1 ] + ( y*z*(1-c)-x*s ) * V[ 2 ],
            ( z*x*(1-c)-y*s ) * V[ 0 ] + ( z*y*(1-c)+x*s ) * V[ 1 ] + ( z*z+(1-z*z)*c ) * V[ 2 ]
        ]

    # scalar multiplication
    @sm: ( x, t ) ->
        [ x[ 0 ] * t, x[ 1 ] * t, x[ 2 ] * t ] 
    
    
    #  Recursive definition of determinant using expansion by minors.
    # taken from http://mysite.verizon.net/res148h4j/javascript/script_determinant3.html
    @determinant: ( a ) ->
        n = a.length
        if n == 1
            a[ 0 ][ 0 ]
        else if n == 2
            a[ 0 ][ 0 ] * a[ 1 ][ 1 ] - a[ 1 ][ 0 ] * a[ 0 ][ 1 ]
        else
            d = 0
            for j1 in [ 0 ... n ]
                m = for i in [ 1 ... n ]
                    for j in [ 0 ... n ] when j != j1
                        a[ i ][ j ]
                d += Math.pow( -1.0, j1 ) * a[ 0 ][ j1 ] * Vec_3.determinant( m )
                
            d
    
    @solve: ( M, B ) ->
        n = B.length
        if M[ 0 ].length?
            d = Vec_3.determinant M
            if M[ 0 ].length != n
                console.log "pb with solve args"
            
            m = for i in [ 0 ... n ]
                for j in [ 0 ... n ]
                    0.0
            for i in [ 0 ... n ]
                for r in [ 0 ... n ]
                    for c in [ 0 ... n ]
                        if c == i
                            m[ r ][ c ] = B[ r ]
                        else
                            m[ r ][ c ] = M[ r ][ c ]
                Vec_3.determinant( m ) / d
        
        else
            m = for i in [ 0 ... n ]
                for j in [ 0 ... n ]
                    M[ n * j + i ]
                    
            Vec_3.solve m, B

    # outer product : a.(b transposed)
    @outprod: ( a, b ) ->
        R = new Mat_3
        for i in [ 0 .. 2 ]
            for j in [ 0 .. 2 ]
                R[ i ][ j ] = a[ i ] * b[ j ]
        return R
    
    # sum of terms
    @sum: ( a ) ->
        return a[ 0 ] + a[ 1 ] + a[ 2 ]