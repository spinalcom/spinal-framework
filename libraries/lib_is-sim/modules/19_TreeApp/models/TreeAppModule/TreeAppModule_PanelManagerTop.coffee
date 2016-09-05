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
class TreeAppModule_PanelManagerTop extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Windows'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id

            
        @actions.push
            ico: "img/close_panel_grey.png"
            siz: 1
            txt: "Close current view (Shift+X)"
            ina: _ina
            fun: ( evt, app ) ->
                app.undo_manager.snapshot()
                app.data.rm_selected_panels()
            key: [ "Shift+X" ]
            
        @actions.push
            ico: "img/vertical_split_grey.png"
            siz: 1
            txt: "Vertical split (Shift+V)"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 0
            key: [ "Shift+V" ]
         
        @actions.push
            ico: "img/horizontal_split_grey.png"
            siz: 1
            txt: "Horizontal split (Shift+H)"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 1
            key: [ "Shift+H" ]
        
        @actions.push
            ico: "img/fit_grey.png"
            siz: 1
            txt: "Fit object to the view (F)"
            ina: _ina
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.fit()
            key: [ "F" ]
            
            
        cube =
            #ico: "img/cube.png"
            siz: 1
            txt: "View"
            ina: _ina
            sub:
                prf: "list"
                act: [ ]
            key: [ "V" ]
        @actions.push cube
        
        @actions.push 
            ico: "img/origin_grey.png"
            txt: "Origin camera (O)"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.origin()
            key: [ "O" ]
            
        @actions.push 
            ico: "img/top_grey.png"
            txt: "Watch top (T)"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.top()
            key: [ "T" ]
            
        cube.sub.act.push 
            txt: "Watch bottom (B)"
            ina: _ina
            vis: false
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.bottom()
            key: [ "B" ]
            
        @actions.push
            ico: "img/right_grey.png"
            txt: "Watch right (R)"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.right()
            key: [ "R" ]
            
        cube.sub.act.push 
            txt: "Watch left (L)"
            ina: _ina
            vis: false
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.left()
            key: [ "L" ]
            
        @actions.push
            ico: "img/eye_closed.png"
            siz: 1
            txt: "Hide all"
            ina: _ina
#             vis: false
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    panel_id = inst.view_item._panel_id
                    inst.app_data.visible_tree_items[ panel_id ].clear()
                    inst.app_data.visible_tree_items[ panel_id ].push inst.view_item
                    inst.cm.fit()
                    
                    
        
        @actions.push
#             ico: "img/zoom_grey.png"
            siz: 1
            txt: "Zoom"
            ina: _ina
#             vis: false
            fun: ( evt, app ) ->
                if not @zoom_area
                    @old_cm = app.selected_canvas_inst()?[ 0 ]?.cm
                    @theme = @old_cm.theme
                    @zoom_area = new ZoomArea @old_cm, zoom_factor : [ @theme.zoom_factor, @theme.zoom_factor, 1 ]
                    @zoom_area.zoom_pos.set [ @old_cm.mouse_x, @old_cm.mouse_y ]
                    @old_cm.items.push @zoom_area
                else
                    @old_cm.items.remove_ref @zoom_area
                    @old_cm.draw()
                    @theme.zoom_factor.set @zoom_area.zoom_factor[ 0 ] # use last zoom_factor as a default for user
                    delete @zoom_area
                    
            key: [ "Z" ]
                
        @actions.push
            txt: ""
            key: [ "UpArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate -0.1, 0, 0

        @actions.push
            txt: ""
            key: [ "DownArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0.1, 0, 0

        @actions.push
            txt: ""
            key: [ "LeftArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0, -0.1, 0
                            
        @actions.push
            txt: ""
            key: [ "RightArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0, 0.1, 0
    

    split_view: ( evt, app, n ) ->
        app.undo_manager.snapshot()
        cam = undefined
        child = undefined
        for p in app.data.selected_tree_items
            s = p[ p.length - 1 ]
            if s instanceof ShootingItem
                cam = s.cam
                child = s
#         console.log cam
                
        d = app.data.selected_display_settings()
        for panel_id in app.data.selected_canvas_pan
            app._next_view_item_cam = cam
            app._next_view_item_child = child
            d._layout.mk_split n, 0, panel_id, 0.5
            
        
        