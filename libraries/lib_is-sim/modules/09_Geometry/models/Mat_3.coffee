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



# a square Matrix of fixed size = 3*3, full of zeros
class Mat_3 extends Vec_3
    constructor: ( ) ->
        # each matrix line is a Vec_3
        this[0] = new Vec_3
        this[1] = new Vec_3
        this[2] = new Vec_3
        this[0] = [0,0,0]
        this[1] = [0,0,0]
        this[2] = [0,0,0]
        
    @sub: ( A, B ) ->
        return [ 
            [ A[ 0 ][ 0 ] - B[ 0 ][ 0 ], A[ 0 ][ 1 ] - B[ 0 ][ 1 ], A[ 0 ][ 2 ] - B[ 0 ][ 2 ] ],
            [ A[ 1 ][ 0 ] - B[ 1 ][ 0 ], A[ 1 ][ 1 ] - B[ 1 ][ 1 ], A[ 1 ][ 2 ] - B[ 1 ][ 2 ] ],
            [ A[ 2 ][ 0 ] - B[ 2 ][ 0 ], A[ 2 ][ 1 ] - B[ 2 ][ 1 ], A[ 2 ][ 2 ] - B[ 2 ][ 2 ] ]
        ]

    @add: ( A, B ) ->
        return [ 
            [ A[ 0 ][ 0 ] + B[ 0 ][ 0 ], A[ 0 ][ 1 ] + B[ 0 ][ 1 ], A[ 0 ][ 2 ] + B[ 0 ][ 2 ] ],
            [ A[ 1 ][ 0 ] + B[ 1 ][ 0 ], A[ 1 ][ 1 ] + B[ 1 ][ 1 ], A[ 1 ][ 2 ] + B[ 1 ][ 2 ] ],
            [ A[ 2 ][ 0 ] + B[ 2 ][ 0 ], A[ 2 ][ 1 ] + B[ 2 ][ 1 ], A[ 2 ][ 2 ] + B[ 2 ][ 2 ] ]
        ]
    
    # term-to-term multiplication 
    @mul: ( A, B ) ->
        return [ 
            [ A[ 0 ][ 0 ] * B[ 0 ][ 0 ], A[ 0 ][ 1 ] * B[ 0 ][ 1 ], A[ 0 ][ 2 ] * B[ 0 ][ 2 ] ],
            [ A[ 1 ][ 0 ] * B[ 1 ][ 0 ], A[ 1 ][ 1 ] * B[ 1 ][ 1 ], A[ 1 ][ 2 ] * B[ 1 ][ 2 ] ],
            [ A[ 2 ][ 0 ] * B[ 2 ][ 0 ], A[ 2 ][ 1 ] * B[ 2 ][ 1 ], A[ 2 ][ 2 ] * B[ 2 ][ 2 ] ]
        ]  
            
    # matrix multiplication (B can be a Mat_3 or a Vec_3)
    @dot: ( A, B ) ->
        if B[0].length == 3
            return [ 
                [ A[ 0 ][ 0 ] * B[ 0 ][ 0 ] + A[ 0 ][ 1 ] * B[ 1 ][ 0 ] + A[ 0 ][ 2 ] * B[ 2 ][ 0 ], 
                A[ 0 ][ 0 ] * B[ 0 ][ 1 ] + A[ 0 ][ 1 ] * B[ 1 ][ 1 ] + A[ 0 ][ 2 ] * B[ 2 ][ 1 ],
                A[ 0 ][ 0 ] * B[ 0 ][ 2 ] + A[ 0 ][ 1 ] * B[ 1 ][ 2 ] + A[ 0 ][ 2 ] * B[ 2 ][ 2 ] ],

                [ A[ 1 ][ 0 ] * B[ 0 ][ 0 ] + A[ 1 ][ 1 ] * B[ 1 ][ 0 ] + A[ 1 ][ 2 ] * B[ 2 ][ 0 ], 
                A[ 1 ][ 0 ] * B[ 0 ][ 1 ] + A[ 1 ][ 1 ] * B[ 1 ][ 1 ] + A[ 1 ][ 2 ] * B[ 2 ][ 1 ],
                A[ 1 ][ 0 ] * B[ 0 ][ 2 ] + A[ 1 ][ 1 ] * B[ 1 ][ 2 ] + A[ 1 ][ 2 ] * B[ 2 ][ 2 ] ],
                
                [ A[ 2 ][ 0 ] * B[ 0 ][ 0 ] + A[ 2 ][ 1 ] * B[ 1 ][ 0 ] + A[ 2 ][ 2 ] * B[ 2 ][ 0 ], 
                A[ 2 ][ 0 ] * B[ 0 ][ 1 ] + A[ 2 ][ 1 ] * B[ 1 ][ 1 ] + A[ 2 ][ 2 ] * B[ 2 ][ 1 ],
                A[ 2 ][ 0 ] * B[ 0 ][ 2 ] + A[ 2 ][ 1 ] * B[ 1 ][ 2 ] + A[ 2 ][ 2 ] * B[ 2 ][ 2 ] ]
            ]        
        else
            return [ 
                A[ 0 ][ 0 ] * B[ 0 ] + A[ 0 ][ 1 ] * B[ 1 ] + A[ 0 ][ 2 ] * B[ 2 ], 
                A[ 1 ][ 0 ] * B[ 0 ] + A[ 1 ][ 1 ] * B[ 1 ] + A[ 1 ][ 2 ] * B[ 2 ],
                A[ 2 ][ 0 ] * B[ 0 ] + A[ 2 ][ 1 ] * B[ 1 ] + A[ 2 ][ 2 ] * B[ 2 ]
            ]
    
    # transposed matrix
    @tra: ( A ) ->
        return [
            [ A[ 0 ][ 0 ], A[ 1 ][ 0 ], A[ 2 ][ 0 ] ],
            [ A[ 0 ][ 1 ], A[ 1 ][ 1 ], A[ 2 ][ 1 ] ],
            [ A[ 0 ][ 2 ], A[ 1 ][ 2 ], A[ 2 ][ 2 ] ]
        ]

    # multiplication by scalar
    @mus: ( s, A ) ->
        return [ 
            [ s * A[ 0 ][ 0 ], s * A[ 0 ][ 1 ], s * A[ 0 ][ 2 ] ],
            [ s * A[ 1 ][ 0 ], s * A[ 1 ][ 1 ], s * A[ 1 ][ 2 ] ],
            [ s * A[ 2 ][ 0 ], s * A[ 2 ][ 1 ], s * A[ 2 ][ 2 ] ]
        ]  

    
    # TODO: compute here all the other operations on matrices
    
    