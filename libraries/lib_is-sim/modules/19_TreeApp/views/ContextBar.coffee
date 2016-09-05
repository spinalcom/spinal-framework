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
class ContextBar extends View
    constructor: ( @el, @tree_app, params = {} ) ->        
        @app_data = @tree_app.data
        super @app_data
        
        @icon_container = new_dom_element
            nodeName  : "div"
            parentNode: @el
        
        @run_compute_action =
            txt: "run"
            fa : "fa-play"
            loc: true
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    if not item._computation_mode.get() and not item._computation_state.get()
                        item.do_it()
                            
#         @processing_compute_action = 
#             txt: "stop"
#             ico: "img/sajax-loader.gif"
#             loc: true
#             fun: ( evt, app ) =>
#                 items = app.data.selected_tree_items
#                 for path_item in items
#                     item = path_item[ path_item.length - 1 ]
#                     if item._computation_state.get() == true or item._pending_state.get() == true or item._processing_state.get() == true or item._finish_state.get() == true
#                         item.stop_it()
#                         
        @stop_compute_action = 
            txt: "stop"
            fa : "fa-stop"
            loc: true
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    if item._computation_state.get() or item._pending_state.get() or item._processing_state.get() or item._finish_state.get()
                        item.stop_it()
        
        
    onchange: ->
        context_actions = new Lst
        processing = false
        #context_actions.set @base_actions
        if @app_data.selected_tree_items.has_been_directly_modified  
            #alert @app_data.selected_tree_items.length
            for path in @app_data.selected_tree_items
                item = path[ path.length - 1 ]
                if (item instanceof TreeItem_Computable)
                  if not item._computation_mode.get() and not item._computation_state.get()
                    context_actions.push @run_compute_action
                  else if item._computation_state.get() or item._pending_state.get() or item._processing_state.get() or item._finish_state.get()
                    processing = true
                    context_actions.push @stop_compute_action
                
                #test
                suppl_act = item.display_context_actions()
                for act in suppl_act
                    if act instanceof TreeAppModule 
                      do ( act ) =>
                        for in_act in act.actions
                          do ( in_act ) =>
                            context_actions.push in_act if not (context_actions.contains(in_act))
                        
                    else 
                      context_actions.push act if not (context_actions.contains(act))
                
                if item._context_actions?
                  #alert item._context_actions.length
                  for act in item._context_actions
                    if act instanceof TreeAppModule 
                      do ( act ) =>
                        for in_act in act.actions
                          do ( in_act ) =>
                            context_actions.push in_act if not (context_actions.contains(in_act))
                        
                    else 
                      context_actions.push act if not (context_actions.contains(act))
                    
                
                    
                    
        @el.appendChild @icon_container
        while @icon_container.firstChild?
            @icon_container.removeChild @icon_container.firstChild
        

        block = new_dom_element
            parentNode : @icon_container
            nodeName   : "span"
        
        
        if processing
            container_icon = new_dom_element
                    parentNode : block
                    nodeName   : "span"
                    className  : "fa fa-cog fa-spin fa-3x fa-fw"
                    style:
                        display: "inline-block"
                        textAlign: "center"
                        width: "100%"
                        margin: "10px 0 0 0"
                    
                    
        for act, j in context_actions when act.vis != false 
            @_select_icon_type_rec act, block, 1

    draw_item: ( act, parent, key, size, prf ) ->               
        do ( act ) =>
            if prf? and prf == "list"
                container_icon = new_dom_element
                    parentNode : parent
                    nodeName   : "img"
                    alt        : act.txt
                    title      : act.txt + key
                    src        : act.ico
                    style      :
                        height     : 30
                    onmousedown: ( evt ) =>
                        act.fun evt, @tree_app
                        parent.classList.toggle "inline"
                        
                new_dom_element
                    parentNode : parent
                    nodeName   : "br"
                  
            else if act.txtico
                container_icon = new_dom_element
                    parentNode : parent
                    nodeName   : "span"
                    className  : "ContextModule"
                    alt        : act.txt
                    title      : act.txt + key
                    onclick   : ( evt ) =>
                        act.fun evt, @tree_app                          
                de = new_dom_element
                    nodeName   : "div"
                    className  : "text_icon"
                    parentNode : container_icon     
                    txt        : act.txtico
                  
            else if act.fa
                faClass = "fa " + act.fa + " fa-2x"
                container_icon = new_dom_element
                    parentNode : parent
                    nodeName   : "span"
                    className  : "ContextModule"
                    alt        : act.txt
                    title      : act.txt + key
                    onclick   : ( evt ) =>
                        act.fun evt, @tree_app                          
                de = new_dom_element
                    nodeName   : "i"
                    className  : faClass
                    parentNode : container_icon

                  
            else
                container_icon = new_dom_element
                    parentNode : parent
                    nodeName   : "span"
                    className  : "ContextModule"
                de = new_dom_element
                    nodeName  : "img"
                    src       : act.ico
                    #className : "FooterTreeViewIcon"
                    parentNode: container_icon
                    alt       : act.txt
                    title     : act.txt
                    style     :
                        height     : 30
                    onclick   : ( evt ) =>
                        act.fun evt, @tree_app      
            return container_icon 
                            
                 
    display_child_menu_container: ( evt, val ) ->
        if val == 1
            containers = document.getElementsByClassName("menu_container")
            menu_container = containers[ containers.length - 1 ]
            menu_container.classList.add "block"
        if val == 0
            containers = document.getElementsByClassName("menu_container")
            menu_container = containers[ containers.length - 1 ]
            menu_container.classList.remove "block"
   
   
    # side menu is an icon who have icon as children
    create_list_menu: ( act, parent, key, size ) =>
        click_container = new_dom_element
            parentNode : parent
            nodeName   : "span"
            className  : "ContextModule"
            
        if act.fa
            faClass = "fa " + act.fa + " fa-2x"
            new_dom_element
                parentNode : click_container
                nodeName   : "i"
                alt        : act.txt
                title      : act.txt + key
                className  : faClass
                onmousedown: ( evt ) =>
                    # assing first action to visible icon
                    act.sub.act[ 0 ]?.fun evt, @tree_app            
        
        else if act.ico? and act.ico.length > 0
            new_dom_element
                parentNode : click_container
                nodeName   : "img"
                alt        : act.txt
                title      : act.txt + key
                src        : act.ico
                className  : "parent_list_icon"
                style      :
                    height     : 30
                    
                onmousedown: ( evt ) =>
                    # assing first action to visible icon
                    act.sub.act[ 0 ]?.fun evt, @tree_app
                            
        arrow_container = new_dom_element
            parentNode : click_container
            nodeName   : "span"
            className  : "arrow_container"
            onmousedown: ( evt ) =>
                child_container.classList.toggle "block"
                     
        arrow = new_dom_element
            parentNode : arrow_container
            nodeName   : "i"
            className  : "fa fa-caret-down fa-lg"
            alt        : ""
            
        #span that will contain hidden icon
        child_container = new_dom_element
            parentNode : parent
            nodeName   : "span"
            className  : "container_hidden_icon"
            id         : "id_hidden_icon"
            
        return child_container
    
    
    _select_icon_type_rec: ( act, parent, size, prf = '' ) ->
        key = @key_as_string act
#         console.log act.txt, parent
        if act.sub? and act.sub.prf? and act.sub.act?
            must_draw_item = false
            act.fun = ( evt, app ) ->
                act.sub.act[ 0 ].fun evt, app
            container = @create_list_menu act, parent, key, size
        
        else 
            container = @draw_item act, parent, key, size, prf
            
        if act.sub?.act?
            for ac, i in act.sub.act
                @_select_icon_type_rec ac, container, size, act.sub.prf

            return true
        return false
        
        
    key_as_string: ( act ) ->
        key = ''
        if act.key?
            key = ' ('
            for k, i in act.key
                if i >= 1
                    key += ' or '
                key += k
            key += ')'
#             
        return key