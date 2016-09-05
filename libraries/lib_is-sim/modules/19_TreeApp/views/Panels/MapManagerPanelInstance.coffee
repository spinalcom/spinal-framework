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



# Link between TreeData and MapManager
class MapManagerPanelInstance extends LayoutManagerPanelInstance
    constructor: ( el, @app_data, @view_item, undo_manager ) ->
        super el
        
        @divMap = document.createElement "div"
        @divMap.style.position = "absolute"
        @_manage_is_chown = false
        #
        @mm = new MapManager
            el            : @divMap
            items         : @app_data.visible_tree_items[ @view_item._panel_id ]
            time          : @app_data.time
            undo_manager  : undo_manager
            
        # active_items
        @mm.active_items = =>
            res = []
            if @mm?.items?
                res = for i in @mm.items  # when i.always_active?()
                    i
                
#             for s in @app_data.selected_tree_items
#                 if s[ s.length - 1 ] not in res
#                     res.push s[ s.length - 1 ]
            res

        @mm.selected_items = =>
            for s in @app_data.selected_tree_items
                s[ s.length - 1 ]
#         
#                 
        @app_data.selected_tree_items.bind @mm
# 
#         #
        @app_data.focus.set @mm.process_id
# 
        @mm.select_canvas_fun.push ( cm, evt ) =>
            @app_data.focus.set @mm.process_id
            
            if evt.ctrlKey
                @app_data.selected_canvas_pan.toggle @view_item._panel_id
            else
                @app_data.selected_canvas_pan.set [ @view_item._panel_id ]
                
            if @app_data.selected_canvas_pan.contains @view_item._panel_id
                @app_data.last_canvas_pan.set @view_item._panel_id
#         
        #
        bind @app_data.selected_canvas_pan, =>
            @_update_borders()

            
    destructor: ->
        super()
        @mm.destructor?()
        delete @mm
        delete @divManager

    # called each time panel is resized (including the first size definition)
    render: ( info ) ->

        @el.appendChild @div
        #@div.appendChild @divTopCanvas
        @div.appendChild @divMap
        @p_min = info.p_min
        @p_max = info.p_max
        @_update_borders()
        
        w = info.p_max[ 0 ] - info.p_min[ 0 ] 
        h = info.p_max[ 1 ] - info.p_min[ 1 ] - 30
        @mm.resize w, h
        @mm.draw()
    #
    _update_borders: ->        
        s = 1 * @app_data.selected_canvas_pan.contains( @view_item._panel_id )
        
        
        @div.style.left   = @p_min[ 0 ] - s
        @div.style.top    = @p_min[ 1 ] - s
        @div.style.width  = @p_max[ 0 ] - @p_min[ 0 ] 
        @div.style.height = @p_max[ 1 ] - @p_min[ 1 ]
        
        @div.onclick = ( evt ) => 
            for fun in @mm.select_canvas_fun
                fun @mm, evt
        #@div.style.background = "#e5e5e5"

        if s
            @div.style.borderWidth = 1
            add_class @div, "SelectedCanvas"
        else
            @div.style.borderWidth = 0
            rem_class @div, "SelectedCanvas"
        
        
        @divMap.style.left   = 0
        @divMap.style.top    = 30
        @divMap.style.width  = @p_max[ 0 ] - @p_min[ 0 ]
        @divMap.style.height = @p_max[ 1 ] - @p_min[ 1 ] - 30
        
        module_manage = new TreeAppModule_MapManagerTop
        @_show_actions_module_manage module_manage.actions, module_manage
        
            
        
    _show_actions: ( module ) ->
        for m in @modules when m instanceof module 
            @_show_actions_module_rec m.actions, module
    
    _show_actions_module_rec: ( actions, module ) ->
        for c in actions when c.ico?
            do ( c ) =>
                elem = new_dom_element
                    parentNode: @menu
                    className : "contextMenuElement"
                    onclick   : ( evt ) => 
                        c.fun evt, @app_data._processes[ 0 ]
                        @_delete_context_menu( evt )
                        
                new_dom_element
                    parentNode: elem
                    nodeName  : "img"
                    src       : c.ico
                    alt       : ""
                    title     : c.txt
                    height    : 24
                    style     :
                        paddingRight: "2px"
                        
                new_dom_element
                    parentNode: elem
                    nodeName  : "span"
                    txt       : c.txt
                    style     :
                        position: "relative"
                        top     : "-5px"
                        
                if c.sub?.act?
                    @_show_actions_module_rec c.sub.act, module
                    return true
              
    
    _show_actions_module_manage: ( actions, module ) ->
        if !@_manage_is_chown
            index_left = 0
            for c in actions when c.ico?
                do ( c ) =>
#                     alert (@p_max[ 0 ] - @p_min[ 0 ] - (index_left * 30) - 2)
                    elem = new_dom_element
                        parentNode: @div
                        style     :
                            paddingRight: "4px"
                            paddingTop: "2px"
                            background : "#262626"
                            width: 30
                            height: 30
                            # "#262626"
                            #display: "block"
                            cssFloat : "right"
                            #zIndex : 1000
                            #position : "relative"
                        onclick   : ( evt ) => 
                            for fun in @mm.select_canvas_fun
                                fun @mm, evt
                            c.fun evt, @app_data._processes[ 0 ]
                    
#                     elem.style.right   = (@p_max[ 0 ] - (index_left * 40) - 5)
#                     elem.style.top    = 0
#                     elem.style.width  = 30
#                     elem.style.height = 30
                                
                    index_left += 1
                    new_dom_element
                        parentNode: elem
                        nodeName  : "img"
                        src       : c.ico
                        alt       : ""
                        title     : c.txt
                        height    : 22
                        style     :
                            marginTop: "2px"
                            paddingRight: "4px"
                            float : "left"
                            
                    if c.sub?.act?
                        @_show_actions_module_manage c.sub.act, module
                        return true
        @_manage_is_chown = true