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



# Browsing and dnd
class ModelEditorItem_Log_List extends ModelEditorItem
    # @see add_action
        # others type can be added by other files

    constructor: ( params ) ->
        super params
        
        @index_sorted  = new Lst # used to delete_file reference to the index to splice 
        @selected_file = new Lst
         
        @selected_file.bind this
        
        @line_height = 30 # enough to contain the text
                
        @ed.ondrop = ( evt ) =>
            @cancel_natural_hotkeys evt
        
        @container = new_dom_element
                parentNode: @ed
                nodeName  : "div"
                className : "directory_container"
                ondragover: ( evt ) =>
#                     this.container.style.border = "thin dashed grey"
                    return false
                ondragout: ( evt ) =>
#                     this.container.style.border = "none"
                    return false
                ondragleave: ( evt ) =>
                    return false
                ondrop: ( evt ) =>
                    evt.stopPropagation()
                    evt.preventDefault()
                    @cancel_natural_hotkeys evt
                    return false
        
            
        @all_file_container = new_dom_element
                parentNode: @container
                nodeName  : "div"

    
    onchange: ->
        if @selected_file.has_been_directly_modified()
            @draw_selected_file()
        if @model.has_been_modified()
            @refresh()

    refresh: ->
        @empty_window()
        @init()
        @draw_selected_file()

    empty_window: ->
        @all_file_container.innerHTML = ""
    
            
    draw_selected_file: ->
        file_contain = document.getElementsByClassName 'line_container'
        for file, j in file_contain
            if parseInt(@selected_file.indexOf j) != -1
                add_class file, 'selected_file'
            else
                rem_class file, 'selected_file'
                
    cancel_natural_hotkeys: ( evt ) ->
        if not evt
            evt = window.event
        evt.cancelBubble = true
        evt.stopPropagation?()
        evt.preventDefault?()
        evt.stopImmediatePropagation?()
        return false
        
    sort_dir = ( a, b ) -> 
        if a.name.get().toLowerCase() > b.name.get().toLowerCase() then 1 else -1
    
    init: ->
#         console.log "---"
        _sorted = @model #.sorted sort_dir
        @index_sorted.clear()
        sorted = new Array
        for elem, i in _sorted
            sorted.push elem
            @index_sorted.push i
        
        for elem, i in sorted
            do ( elem, i ) =>
                log_line = new_dom_element
                    parentNode: @all_file_container
                    nodeName  : "div"
                    className : "line_container"
                    style:
                        width: "100%"
                        height: 30
                        cursor: "pointer"
                        borderBottom: "1px solid grey"
                        
                    onclick: ( evt ) ->
                        elem.load ( object, err ) =>
                            mv = new MessageView object, evt  
                            
                log_name = new_dom_element
                    parentNode: user_line
                    nodeName  : "div"
                    className : "line_message_container"
                    txt : elem.application.name
                    style:
                        margin: "5px 0px 0px 10px" 
                        padding: "0px 0px 0px 30px" 
                        textAlign : "left"
                        cssFloat : "left"
                        #fontWeight : "bold"
                        fontSize   : "18px"
                        
#                     share_button = new_dom_element
#                         parentNode: message_line
#                         className : "share_button"
#                         nodeName  : "div"
#                         alt       : "Share"
#                         title     : "Share"
#                         style:
#                             cssFloat : "right"
#                             margin: "0px 10px 0px 0px"
#                         onclick: ( evt ) =>
#                             @share_popup evt, elem, elem.name.get()

                
    path: ->
        "test_need_to_be_complete"  
        
    
    @add_action: ( model_type, fun ) ->
        if not ModelEditorItem_Directory._action_list[ model_type ]?
            ModelEditorItem_Directory._action_list[ model_type ] = []
        ModelEditorItem_Directory._action_list[ model_type ].push fun
        
        
    
