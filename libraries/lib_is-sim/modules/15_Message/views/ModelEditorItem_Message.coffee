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
class ModelEditorItem_Message extends ModelEditorItem
    # @see add_action
    @_action_list : 
        "Directory": [
            ( file, path, browser ) -> 
                browser.load_folder file
        ]
        # others type can be added by other files

    constructor: ( params ) ->
        super params
        @initial_path   = if params.initial_path? then params.initial_path else "Root"
        
        @initial_path = @make_initial_path_as_dom @initial_path
        
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
                    @handle_files evt.dataTransfer.files
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
    
    load_folder: ( file ) ->
        @model.unbind this
        file._ptr.load ( m, err ) =>
            @model = m
            @model.bind this
            
            @selected_file.clear()
            
    open: ( file, path ) ->
        if file._info.model_type?
            l = ModelEditorItem_Directory._action_list[ file._info.model_type ]
            if l? and l.length
                l[ 0 ] file, path, this
    
    handle_files: ( files ) ->
        if files.length > 0
            if FileSystem?
                fs = FileSystem.get_inst()
                for file in files
                    # TODO: make a model of the correct type (containing a Path)
                    @model.add_file file.name, new Path file

    make_initial_path_as_dom: ( initial_path ) ->
        reg = new RegExp("[\/]+", "g");
        path = initial_path.split reg
        return path
        
    
    search_ord_index_from_id: ( id ) ->
        sorted = @model.sorted sort_dir
        id_ = @index_sorted[ id ]
        for i in @model
            pos = @model.indexOf sorted[ id_ ]
            if pos != -1
                return pos
        
    sort_numerically = ( a, b ) ->
        return (a - b)
    
    delete_file : (file) ->
        for i in [ 0 .. @model.length ]
            if @model[i] == file
                @model.splice i, 1
                return
            
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
        _sorted = @model.sorted sort_dir
        @index_sorted.clear()
        sorted = new Array
        for elem, i in _sorted
            sorted.push elem
            @index_sorted.push i
        
        for elem, i in sorted
#             if not elem.name.get().match( /^\./)
            if not (elem.name.get().match( /^__/) and elem.name.get().match( /__$/))
                do ( elem, i ) =>
                    message_line = new_dom_element
                        parentNode: @all_file_container
                        nodeName  : "div"
                        className : "line_container"
                        style:
                            width: "100%"
                            height: 30
                            cursor: "pointer"
                            borderBottom: "1px solid grey"
                            
                        ondblclick: ( evt ) ->
                            elem.load ( object, err ) =>
                                mv = new MessageView object, evt  
                                
                    message_name = new_dom_element
                        parentNode: message_line
                        nodeName  : "div"
                        className : "line_message_container"
                        txt : elem.name
                        style:
                            margin: "5px 0px 0px 10px" 
                            padding: "0px 0px 0px 30px" 
                            textAlign : "left"
                            cssFloat : "left"
                            #fontWeight : "bold"
                            fontSize   : "18px"
                    
                    delete_button = new_dom_element
                        parentNode: message_line
                        className : "delete_button"
                        nodeName  : "div"
                        alt       : "Delete message"
                        title     : "Delete message"
                        style:
                            cssFloat : "right"
                            margin: "0px 10px 0px 0px"
                        onclick: ( evt ) =>
                            @delete_file elem
                    
                    share_button = new_dom_element
                        parentNode: message_line
                        className : "share_message_button"
                        nodeName  : "div"
                        alt       : "Share"
                        title     : "Share"
                        style:
                            cssFloat : "right"
                            margin: "0px 10px 0px 0px"
                        onclick: ( evt ) =>
                            @share_popup evt, elem, elem.name.get()
                            
                    

                
    path: ->
        "test_need_to_be_complete"
        
    share_popup: ( evt, elem, name_folder ) ->
        email = prompt "share '" + name_folder + "' with (is'sim login) ?"
        ia = email.indexOf "@"
        if ia < 0
            return alert "Please enter a valid login (email adress)"
        login = email #.slice 0, ia
        console.log email, ia, login
        
        fs = FileSystem.get_inst()

        fs.load "__users__/" + login, ( home, err ) ->
            if err
                return alert "Please enter a valid login (email adress --)"
            fs.load_or_make_dir "__users__/" + login + "/__messages__", ( inbox, err ) ->
                if err
                    return alert "??"
                nn = name_folder
                while inbox.has nn
                    ip = nn.indexOf "."
                    if ip < 0
                        ip = nn.length
                    nn = nn.slice( 0, ip ) + "_" + nn.slice( ip, nn.length )
                inbox.push elem
                #inbox.add_file nn, elem._ptr, model_type: elem._info.model_type.get() if elem._info.model_type?, icon: elem._info.icon.get() if elem._info.icon?
        return
    
        @popup_share_div = new_dom_element
            id        : "popup_share_div"
            #             style :
            #                 overflowY  : "hidden"
        
        Ptop   = 100
        Pleft  = 100
        Pwidth = 800 
        Pheight = 260 
        
        @container_share_div = new_dom_element
            parentNode: @popup_share_div
            className : "container_share_div"
            nodeName   : "div"
            style:
                height     : 200
                width      : 200
                margin     : "0px 0 0 10px"
#                 border     : "1px solid blue"
                
            
        @share_user_information_div = new_dom_element
            parentNode: @popup_share_div
            className : "share_user_information_div"
            nodeName   : "div"
            style:
                cssFloat   : "left"
                height     : 200
                width      : 560
                margin     : "0px 0 0 0px"
#                 border     : "1px solid blue"
                
        line_div = new_dom_element
            parentNode: @share_user_information_div
            nodeName   : "div"
            style : 
                cssFloat   : "left"
                height     : 40
                width      : "100%"
                fontSize   : "18px"
                background : "#262626"
                margin     : "60px 0 0 0px"
        
        name_div = new_dom_element
            parentNode: line_div
            nodeName   : "div"
            txt : " email : "
            style : 
                cssFloat   : "left"
                height     : 30
                width      : 100
                margin     : "10px 0 0 10px"
                
        value_div = new_dom_element
            parentNode: line_div
            nodeName   : "input"
            id   : "share_email_input"
            style : 
                cssFloat   : "left"
                height     : 30
                width      : 400
                margin     : "5px 0 0 0px"
                fontWeight : "bold"    
        
        
        link_modifie_informations = new_dom_element
            parentNode : @share_user_information_div
            nodeName   : "button" 
            txt        : "Share"
            className  : "user_line"
            style      :
                height     : 40
                width      : 100
                border     : "none"
                margin     : "15px 60px 0 0"
                cssFloat   : "right"
                fontSize   : "18px"
                color      : "#262626"
                cursor     : "pointer"
                background : "#4dbce9"
                onmousedown: ( evt ) =>
                    # UserEditView.get_change_user_information this 
        
        
        p = new_popup "Share: " + name_folder, event: evt, child: @popup_share_div, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, background: "#262626",  onclose: =>
            @onPopupClose( )
        
        
    onPopupClose: ( ) =>
        document.onkeydown = undefined
        @clear_page(@popup_share_div)
    
    clear_page: ( div_to_clear ) ->
        while div_to_clear.firstChild?
            div_to_clear.removeChild div_to_clear.firstChild     
        
        
    
    @add_action: ( model_type, fun ) ->
        if not ModelEditorItem_Directory._action_list[ model_type ]?
            ModelEditorItem_Directory._action_list[ model_type ] = []
        ModelEditorItem_Directory._action_list[ model_type ].push fun
        
        
    
