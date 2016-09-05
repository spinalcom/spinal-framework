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
class PointMesher extends Drawable
    constructor: ( pos = [ 0, 0, 0 ], density = 2, radius = 6 )->
        super()
        
        
        @add_attr
            point     : new Point pos
            density   : density
            radius    : radius 
            # behavior
            _selected : new Lst # references of selected point
            _pre_sele : new Lst # references of selected point
            
            
    z_index: ->
        return 1000

    
    draw: ( info ) ->
        if info.ctx_type == 'gl'
            # preparation
            selected = {}
            for item in @_selected
                selected[ item.model_id ] = true
                
            _pre_sele = {}
            for item in @_pre_sele
                _pre_sele[ item.model_id ] = true
        
            points          = new PointTheme( new Color( 255, 255, 255, 255 ), @radius.get(), new Color( 255, 255, 255, 255 ), 1 )
            editable_points = new PointTheme( new Color(   0, 255,   0, 255 ), @radius.get(), new Color( 255, 255, 255, 255 ), 1 )
            selected_points     = new PointTheme( new Color( 255,   0,   0, 255 ), @radius.get(), new Color( 255, 255, 255, 255 ), 1 )
            highlighted_points  = new PointTheme( new Color(   0,   0,   0,   0 ), @radius.get(), new Color( 255,   0,   0, 255 ), 1 )
            
            proj = info.re_2_sc.proj @point.pos.get()
            # std points
            editable_points.beg_ctx info
            points.draw_proj info, proj
            editable_points.end_ctx info
            
            # selected points
            if selected[ @point.model_id ]?
               selected_points.beg_ctx info
               n = info.re_2_sc.proj @point.pos.get()
               selected_points.draw_proj info, n
               selected_points.end_ctx info
            
            # preselected points
            if _pre_sele[ this.model_id ]?
                highlighted_points.beg_ctx info
                n = info.re_2_sc.proj @point.pos.get()
                highlighted_points.draw_proj info, n
                highlighted_points.end_ctx info
            
        else
            # preparation
            selected = {}
            for item in @_selected
                selected[ item.model_id ] = true
                
            _pre_sele = {}
            for item in @_pre_sele
                _pre_sele[ item.model_id ] = true
            proj = info.re_2_sc.proj @point.pos.get()
                
            # draw points
            info.ctx.lineWidth   = 1
            info.ctx.strokeStyle = "#993311"
            info.ctx.fillStyle = "#553311"
            if selected[ @point.model_id ]?
                info.ctx.strokeStyle = "#FF0000"
            else
                info.ctx.strokeStyle = "#FFFF00"
            
            info.ctx.beginPath()
            info.ctx.arc proj[ 0 ], proj[ 1 ], @radius.get(), 0, Math.PI * 2, true
            info.ctx.closePath()
            info.ctx.fill()
            info.ctx.stroke()
                
            if _pre_sele[ this.model_id ]?
                info.ctx.fillStyle = "#FFDD22"
                info.ctx.beginPath()
                info.ctx.lineWidth = 0.8
                info.ctx.arc proj[ 0 ], proj[ 1 ], @radius.get() * 0.5, 0, Math.PI * 2, true
                info.ctx.fill()

                info.ctx.closePath()
    
    get_movable_entities: ( res, info, pos, phase ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        if phase == 0
            proj = info.re_2_sc.proj @point.pos.get()
            dx = x - proj[ 0 ]
            dy = y - proj[ 1 ]
            d = Math.sqrt dx * dx + dy * dy
            if d <= 10
                res.push
                    item: @point
                    dist: d
                    type: "PointMesher"
                
                        
    on_mouse_down: ( cm, evt, pos, b ) ->
        delete @_movable_entity
        
        if b == "LEFT" or b == "RIGHT"
            
            # look if there's a movable point under mouse
            for phase in [ 0 ... 3 ]
                # closest entity under mouse
                res = []
                @get_movable_entities res, cm.cam_info, pos, phase
                if res.length
                    res.sort ( a, b ) -> b.dist - a.dist
                    @_movable_entity = res[ 0 ].item
                    
                    if evt.ctrlKey # add / rem selection
                        @_selected.toggle_ref @_movable_entity
                        if not @_selected.contains_ref @_movable_entity
                            delete @_movable_entity
                    else
                        @_selected.clear()
                        @_selected.push @_movable_entity
                        @_movable_entity.beg_click pos
                        
                    if b == "RIGHT"
                        return false
                        
                    return true
                else
                    @_selected.clear()
                    
        return false
                    
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        
        if b == "LEFT" and @_movable_entity?
            cm.undo_manager?.snapshot()
                
            p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
            d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
            
#             console.log p_0
#             console.log d_0
            @_movable_entity.move @_selected, @_movable_entity.pos, p_0, d_0
            
            return true

        # pre selection
#         console.log "test1"
        res = []
        x = pos[ 0 ]
        y = pos[ 1 ]
        
        proj = cm.cam_info.re_2_sc.proj @point.pos.get()
        dx = x - proj[ 0 ]
        dy = y - proj[ 1 ]
        d = Math.sqrt dx * dx + dy * dy
        if d <= 10
            res.push
                item: this
                dist: d
                
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            if @_pre_sele.length != 1 or @_pre_sele[ 0 ] != res[ 0 ].item
                @_pre_sele.clear()
#                 console.log "test"
                @_pre_sele.push res[ 0 ].item
                
        else if @_pre_sele.length
            @_pre_sele.clear()
        
        return false
        
    # onmousemove func
#         if @lock.get() != true
#             @old_points[ i ].set @cur_points[ i ].get()
#             res.push
#                 item: @old_points[ i ]
#                 dist: d
#                 type: "Transform"