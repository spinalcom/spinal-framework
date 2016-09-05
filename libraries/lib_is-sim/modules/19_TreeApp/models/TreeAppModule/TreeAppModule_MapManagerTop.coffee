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
class TreeAppModule_MapManagerTop extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Windows'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id

            
        @actions.push
            ico: "img/close_panel_grey.png"
            siz: 1
            txt: "Close current view"
            ina: _ina
            fun: ( evt, app ) ->
                app.undo_manager.snapshot()
                app.data.rm_selected_panels()
            key: [ "Shift+X" ]
            
        @actions.push
            ico: "img/vertical_split_grey.png"
            siz: 1
            txt: "Vertical Split"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 0
            key: [ "Shift+V" ]
         
        @actions.push
            ico: "img/horizontal_split_grey.png"
            siz: 1
            txt: "Horizontal Split"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 1
            key: [ "Shift+H" ]
        
            
#         @actions.push
#             ico: "img/eye_closed.png"
#             siz: 1
#             txt: "hide all"
#             ina: _ina
# #             vis: false
#             fun: ( evt, app ) ->
#                 for inst in app.selected_canvas_inst()
#                     panel_id = inst.view_item._panel_id
#                     inst.app_data.visible_tree_items[ panel_id ].clear()
#                     inst.app_data.visible_tree_items[ panel_id ].push inst.view_item
#                     inst.cm.fit()
                    
    

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
            
        
        