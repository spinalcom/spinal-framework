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
class ModelEditorItem_Organisation extends ModelEditorItem
    @_action_list : 
        "Directory": [
            ( file, path, browser ) -> 
                browser.load_folder file
        ]
        # others type can be added by other files

    constructor: ( params ) ->
        super params
        @use_icons      = if params.use_icons? then params.use_icons else true
        @initial_path = if params.initial_path? then params.initial_path else "Root"
        @initial_path = @make_initial_path_as_dom @initial_path
        
        @index_sorted  = new Lst # used to delete_file reference to the index to splice 
        @selected_file = new Lst
        
        @selected_file.bind this
        
        @allow_shortkey = false # allow the use of shortkey like Ctrl+C / Delete. Set to false when renaming
        
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
                    
        if @use_icons
            ModelEditorItem_Organisation.new_organisation_button this
            
        @all_file_container = new_dom_element
                parentNode: @container
                nodeName  : "div"

        
        key_map = {              
            13 : ( evt ) => # enter
                if @selected_file.length > 0
                    for ind_sel_file in @selected_file.get()
                        index = @search_ord_index_from_id ind_sel_file
                        @open @model[ index ], @path()
                
            37 : ( evt ) => # left
                if @selected_file.length > 0
                    if evt.shiftKey
                        index_last_file_selected = @selected_file[ @selected_file.length - 1 ].get()
                        
                        if not @reference_file?
                            @selected_file.clear()
                            @selected_file.push index_last_file_selected
                            @reference_file = index_last_file_selected
                        
                        if index_last_file_selected > 0
                            if index_last_file_selected <= @reference_file
                                @selected_file.push index_last_file_selected - 1
                            else
                                @selected_file.pop()
                    else
                        ind = @selected_file[ @selected_file.length - 1 ].get()
                        if ind != 0
                            @selected_file.clear()
                            @selected_file.push ind - 1
                        else
                            @selected_file.clear()
                            @selected_file.push 0
                            
                        @reference_file = undefined
                
                # case no file is selected
                else
                    @selected_file.push 0 
                    @reference_file = undefined
                
                
            39 : ( evt ) => # right
                if @selected_file.length > 0
                    if evt.shiftKey
                        index_last_file_selected = @selected_file[ @selected_file.length - 1 ].get()
                        if not @reference_file?
                            @selected_file.clear()
                            @selected_file.push index_last_file_selected
                            @reference_file = index_last_file_selected
                        
                        if index_last_file_selected < @model.length - 1
                            if index_last_file_selected >= @reference_file
                                @selected_file.push index_last_file_selected + 1
                            else
                                @selected_file.pop()
                    else
                        ind = @selected_file[ @selected_file.length - 1 ].get()
                        if ind < @model.length - 1
                            @selected_file.clear()
                            @selected_file.push ind + 1
                        else
                            @selected_file.clear()
                            @selected_file.push @model.length - 1
                        @reference_file = undefined
                # case no file is selected
                else
                    @selected_file.push 0 
                    
                
            40 : ( evt ) => # down
                if evt.altKey
                    if @selected_file.length > 0
                        for ind_sel_file in @selected_file.get()
                            index = @search_ord_index_from_id ind_sel_file
                            @open @model[ index ], @path()
                
            65 : ( evt ) => # A
                if evt.ctrlKey # select all
                    @selected_file.clear()
                    for child, i in @model
                        @selected_file.push i
                    
                
            46 : ( evt ) => # suppr
                @delete_file()
                
            113 : ( evt ) => # F2
                file_contain = document.getElementsByClassName('selected_file')[ 0 ]?.getElementsByClassName('linkDirectory')
                if file_contain? and file_contain.length > 0
                    @rename_file file_contain[ 0 ], @model[ @search_ord_index_from_id @selected_file[ 0 ].get() ]
                
#             116 : ( evt ) => # F5
#                 @refresh()
        }

        document.onkeydown = ( evt ) =>
            if @allow_shortkey == true
                if key_map[ evt.keyCode ]?
                    evt.stopPropagation()
                    evt.preventDefault()
                    key_map[ evt.keyCode ]( evt )
                    return true   
        
    rename_file: ( file, child_index ) ->
        # start rename file
        @allow_shortkey = false
        file.contentEditable = "true"
        file.focus()
        # stop rename file
        file.onblur = ( evt ) =>
            @allow_shortkey = true
            title = file.innerHTML
            child_index.name.set title
            child_index.load ( organisation, err ) =>
                organisation.name.set title
            file.contentEditable = "false"
            @selected_file.clear()#TODO can be remove when selected_file will not contain index
    
    
    @new_organisation_button: ( this_instance ) ->
        div_top = new_dom_element
            parentNode: this_instance.container
            className : "desk_panel_title"
        
        new_dom_element
            parentNode: div_top
            nodeName: "div"
            txt: "Organisation" 
            style:
                margin: "5px 20px 0px 0px"
                height: "30px"
                cssFloat : "left"
        
        new_dom_element
            parentNode: div_top
            nodeName: "button"
            className : "desk_panel_button"
            txt: "New organisation" 
            style:
                margin: "3px 0px 0px 0px"
                padding: "0px 10px 0px 10px"
                height: "20px"
                cssFloat : "left"
            onclick: ( evt ) ->
                this_instance.new_organisation()  
    
    
    new_organisation: ( ) =>
        #fs = new FileSystem
        fs = @get_fs_instance()
        Organisation_dir = FileSystem._home_dir + "/__organisations__"
        
        config = @config 
        name = prompt "Orgnaisation name", ""
        if name != ""
            organisation = new Organisation name, config
            fs.load_or_make_dir Organisation_dir, ( current_dir, err ) -> 
                current_dir.add_file name, organisation, model_type: "Organisation"#, icon: "organisation"
            fs.load_or_make_dir "/__organisations__", ( current_dir, err ) -> 
                current_dir.force_add_file name, organisation, model_type: "Organisation"#, icon: "organisation"      
        else
            alert "you must type a name !"
                
    
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
            l = ModelEditorItem_Organisation._action_list[ file._info.model_type ]
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
    
    delete_file: ->
        if @selected_file.length
            index_array = []
            for i in @selected_file.get()
                index = @search_ord_index_from_id i
                index_array.push index
            index_array.sort @sort_numerically
            
            for i in [ index_array.length - 1 .. 0 ]
                @model.splice index_array[ i ], 1
                
            @selected_file.clear()
            
    draw_selected_file: ->
        file_contain = document.getElementsByClassName 'file_container'
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
            if elem._info.model_type.get() == "Organisation"
                sorted.push elem
                @index_sorted.push i

        @allow_shortkey = true
        
        for elem, i in sorted
            do ( elem, i ) =>
                file_container = new_dom_element
                    parentNode: @all_file_container
                    nodeName  : "div"
                    className : "file_container"
                        
                    onmousedown : ( evt ) =>
                        if evt.ctrlKey
                            ind = parseInt(@selected_file.indexOf i)
                            if ind != -1
                                @selected_file.splice ind, 1
                            else
                                @selected_file.push i
                                
                        else if evt.shiftKey
                            if @selected_file.length == 0
                                @selected_file.push i
                            else
                                index_last_file_selected = @selected_file[ @selected_file.length - 1 ].get()
                                @selected_file.clear()
                                for j in [ index_last_file_selected .. i ]
                                    @selected_file.push j
                                
                        else
                            @selected_file.clear()
                            @selected_file.push i
                   
               
                @picture = new_dom_element
                    parentNode: file_container
                    nodeName  : "img"
                    src       : "img/organisation.png"
                    alt       : ""
                    title     : "" 
                    ondblclick: ( evt ) =>
                        conf = @config
                        elem.load ( organisation, err ) ->                            
                            conf.selected_organisation.clear()
                            conf.selected_organisation.push organisation 
                            
                            myWindow = window.open '',''
                            myWindow.document.location = "organisation.html"
                            myWindow.focus()  
                
                #button line
                button_line = new_dom_element
                    parentNode: file_container
                    className : "line_button"
                    nodeName  : "div"
                                  
                share_button = new_dom_element
                    parentNode: button_line
                    className : "share_button"
                    nodeName  : "div"
                    alt       : "Share"
                    title     : "Share"
                    onclick: ( evt ) =>
                        @share_popup evt, elem, elem.name.get()
                
                select_button = new_dom_element
                    parentNode: button_line
                    className : if (@config.selected_organisation[0]? and @config.selected_organisation[0].name.get() == elem.name.get() ) then "select_organisation_button" else "unselect_organisation_button"
                    nodeName  : "div"
                    alt       : "Select organisation"
                    title     : "Select organisation"
                    onclick: ( evt ) =>
                        conf = @config
                        elem.load ( organisation, err ) ->                            
                            conf.selected_organisation.clear()
                            conf.selected_organisation.push organisation 
                        
                        
                #Show file name
                text = new_dom_element
                    parentNode: file_container
                    className : "linkDirectory"
                    nodeName  : "div"
                    txt       : elem.name.get()
                    onclick: ( evt ) =>
                        @rename_file text, sorted[ i ]

    
    get_fs_instance: ( ) =>
        if FileSystem? and FileSystem.get_inst()?
            fs = FileSystem.get_inst()
            return fs
        else
            fs = new FileSystem
            FileSystem._disp = false
            return fs
    
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
            fs.load_or_make_dir "__users__/" + login + "/__organisations__", ( inbox, err ) ->
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
        if not ModelEditorItem_Organisation._action_list[ model_type ]?
            ModelEditorItem_Organisation._action_list[ model_type ] = []
        ModelEditorItem_Organisation._action_list[ model_type ].push fun
        
        
