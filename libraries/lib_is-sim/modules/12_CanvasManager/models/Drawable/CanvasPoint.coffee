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
class CanvasPoint extends Drawable
    constructor: ( pos = [ 0, 0, 0 ], params = {} )->
        super()
        
        @add_attr
            name      : "Point"
            point     : new Point pos
            radius    : new ConstrainedVal( 6, { min: 1, max: 20 } )
            color     : if params.color? then params.color else new Color( 255, 255, 255, 255 )
            _edge_color: if params.edge_color? then params.edge_color else new Color( 0, 0, 0, 255 )
            
        if params.radius? then @radius.set params.radius
            
    z_index: ->
        return 1000

    
    draw: ( info ) ->
        if info.ctx_type == 'gl'
        
            points          = new PointTheme( @color, @radius.get(), @_edge_color, 1 )
#             editable_points = new PointTheme( new Color(   0, 255,   0, 255 ), @radius.get(), new Color( 255, 255, 255, 255 ), 1 )
            
            proj = info.re_2_sc.proj @point.pos.get()
            points.beg_ctx info
            points.draw_proj info, proj
            points.end_ctx info
        
        else
            proj = info.re_2_sc.proj @point.pos.get()
                
            # draw points
            info.ctx.lineWidth   = 1
            info.ctx.strokeStyle = "#993311"
            info.ctx.fillStyle = "#553311"
            info.ctx.strokeStyle = "#FF0000"
            info.ctx.strokeStyle = "#FFFF00"
            
            info.ctx.beginPath()
            info.ctx.arc proj[ 0 ], proj[ 1 ], @radius.get(), 0, Math.PI * 2, true
            info.ctx.closePath()
            info.ctx.fill()
            info.ctx.stroke()
            
