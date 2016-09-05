# Copyright 2015 SpinalCom  www.spinalcom.com
#
# This file is part of SpinalCore.
#
# SpinalCore is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SpinalCore is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with SpinalCore. If not, see <http://www.gnu.org/licenses/>.



# Browsing and dnd
class AdminModelEditorItem_Directory extends ModelEditorItem
    # @see add_action
    @_action_list : 
        "Directory": [
            ( file, path, browser ) -> 
                browser.load_folder file
        ]
        # others type can be added by other files
        
    # @see add_action_2
    @_action_list_2 : []
        # others type can be added by other files

    constructor: ( params ) ->
        super params
        @use_breadcrumb = if params.use_breadcrumb? then params.use_breadcrumb else true
        @use_icons      = if params.use_icons? then params.use_icons else true
        @initial_path   = if params.initial_path? then params.initial_path else "Root"
        @use_upload     = if params.use_upload? then params.use_upload else true
        @use_share      = if params.use_share? then params.use_share else true
        @use_download   = if params.use_download? then params.use_download else true        
        @use_manage     = if params.use_manage? then params.use_manage else true
        
        @display        = if params.display? then params.display else "all"
        
        @breadcrumb = new Lst
        @breadcrumb.push @model
        @breadcrumb.bind this
        
        @initial_path = @make_initial_path_as_dom @initial_path
        
        @index_sorted  = new Lst # used to delete_file reference to the index to splice 
        @selected_file = new Lst
        @clipboard     = new Lst # contain last 'copy' or 'cut' file
        
            
        @selected_file.bind this
        @clipboard.bind this
        
        
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
         
         if @use_icons or @use_upload       
            @icon_scene = new_dom_element
                        parentNode: @container
                        nodeName  : "div"
                        className : "icon_scene"
                        
            title =  new_dom_element
                        parentNode: @icon_scene
                        nodeName  : "div"
                        txt : "Files"
                        style :
                            cssFloat : "left"
                            padding: "6px 40px 0 30px"
        
        if @use_icons         
            @icon_up = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "img"
                    src       : "img/parent_20.png"
                    alt       : "Parent"
                    title     : "Parent"
                    style :
                        cssFloat : "left"
                        height : 20
                    onclick: ( evt ) =>
                        # watching parent
                        @load_model_from_breadcrumb @breadcrumb.length - 2
                        
            @icon_new_folder = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "img"
                    src       : "img/add_folder_20.png"
                    alt       : "New folder"
                    title     : "New folder"
                    style :
                        cssFloat : "left"
                        height : 20
                    onclick: ( evt ) =>
                        t = new Directory
                        @model.add_file "New folder", t
#                         n._info.add_attr
#                             icon: "folder"
#                             model_type: "Directory"
                            
#                         @model.push n
    #                     @refresh()
                        
            @icon_cut = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "img"
                    src       : "img/cut_20.png"
                    alt       : "cut"
                    title     : "Cut"
                    style :
                        cssFloat : "left"
                        height : 20
                    onclick: ( evt ) =>
                        @cut()
                        
            @icon_copy = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "img"
                    src       : "img/copy_20.png"
                    alt       : "copy"
                    title     : "Copy"
                    style :
                        cssFloat : "left"
                        height : 20
                    onclick: ( evt ) =>
                        @copy()
                        
            @icon_paste = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "img"
                    src       : "img/paste_20.png"
                    alt       : "paste"
                    title     : "Paste"
                    style :
                        cssFloat : "left"
                        height : 20
                    onclick: ( evt ) =>
                        @paste()

            @icon_del_folder = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "img"
                    src       : "img/trash_20.png"
                    alt       : "Delete"
                    title     : "Delete"
                    style :
                        cssFloat : "left"
                        height : 22
                    onclick: ( evt ) =>
                        @delete_file()
                    ondragover: ( evt ) =>
                        return false
                    ondrop: ( evt ) =>
                        @delete_file()
                        evt.stopPropagation()
                        return false
            
        if @use_upload
            @upload_form = new_dom_element
                    parentNode: @icon_scene
                    nodeName  : "form"
                    style :
                        cssFloat : "left"
                        padding: "0px 0px 0 30px"
                    
#             @txt_upload = new_dom_element
#                     parentNode: @icon_scene
#                     nodeName  : "span"
#                     txt       : "Add new file(s) "
#                     style :
#                         cssFloat : "left"
#                         fontWeight: "normal"
#                         fontSize: 14
#                         padding: "5px 0px 0 0px"
                    
            @upload = new_dom_element
                parentNode: @icon_scene
                nodeName  : "input"
                type      : "file"
                multiple  : "true"
                style :
                        cssFloat : "left"
                        fontWeight: "normal"
                        fontSize: 14
                        padding: "0px 0px 0 0px"
                        border : "none"
                        background : "#4dbce9"
                onchange  : ( evt ) =>
                    @handle_files @upload.files
                                
        
        if @use_breadcrumb
            @breadcrumb_line = new_dom_element
                parentNode: @container                
                nodeName  : "div"
                style :
                    width: "100%"
                    #background : "#262626"
                    borderBottom : "1px solid #262626"
        
            @breadcrumb_dom = new_dom_element
                parentNode: @breadcrumb_line                
                nodeName  : "div"
                style :
                    fontWeight: "normal"
                    fontSize: 14
                    padding: "5px 0px 0 20px"
                    border : "none"
                        
            
        @all_file_container = new_dom_element
                parentNode: @container
                nodeName  : "div"

        
        key_map = {
            8 : ( evt ) => # backspace
                @load_model_from_breadcrumb @breadcrumb.length - 2
                        
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
                
            38 : ( evt ) => # up
                if evt.altKey
                    @load_model_from_breadcrumb @breadcrumb.length - 2
                
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
                    
            88 : ( evt ) => # X
                if evt.ctrlKey # cut
                    @cut()
                
            67 : ( evt ) => # C
                if evt.ctrlKey # copy
                    @copy()
                
            86 : ( evt ) => # V
                if evt.ctrlKey # paste
                    @paste()
                
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

    
    cut: ->
        if @use_manage
            if @selected_file.length > 0
                @clipboard.clear()
                for ind_children in @selected_file.get()
                    real_ind = @search_ord_index_from_id ind_children
                    @clipboard.push @model[ real_ind ]
                @cutroot = @model
            
    copy: ->
        if @use_manage
            if @selected_file.length > 0
                @clipboard.clear()
                for ind_children in @selected_file.get()
                    real_ind = @search_ord_index_from_id ind_children
                    @clipboard.push @model[ real_ind ]
                @cutroot = undefined
            
    paste: ->
        if @use_manage
            if @cutroot?
                for mod in @clipboard.get()
                    pos = @cutroot.indexOf mod
                    if pos != -1
                        @cutroot.splice pos, 1
            for file in @clipboard
                new_file = file.deep_copy()
                @model.push new_file
        
        
    rename_file: ( file, child_index ) ->
        if @use_manage
            # start rename file
            @allow_shortkey = false
            file.contentEditable = "true"
            file.focus()
            # stop rename file
            file.onblur = ( evt ) =>
                @allow_shortkey = true
                title = file.innerHTML
                child_index.name.set title
                file.contentEditable = "false"
                @selected_file.clear()#TODO can be remove when selected_file will not contain index
    
    onchange: ->
        if @selected_file.has_been_directly_modified()
            @draw_selected_file()
        if @model.has_been_modified() or @breadcrumb.has_been_modified()
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
            
            @breadcrumb.push file
            @selected_file.clear()
            
    open: ( file, path ) ->
        if file._info.model_type?
            l = ModelEditorItem_Directory._action_list[ file._info.model_type ]
            if l? and l.length
                l[ 0 ] file, path, this
                
    open_2: ( file, path ) ->
        if file._info.model_type?
            l = ModelEditorItem_Directory._action_list_2[ file._info.model_type ]
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
#         console.log path
#         for folder in path[ 1 ... path.length ]
#         
#         console.log @breadcrumb
#         console.log @breadcrumb_dom
# #         @breadcrumb = path.concat @breadcrumb
#         console.log @breadcrumb
        return path
        
    draw_breadcrumb: ->
        @breadcrumb_dom.innerHTML = ""
        for folder, i in @breadcrumb
            do ( i ) =>
                if i == 0
                    f = new_dom_element
                        parentNode: @breadcrumb_dom
                        nodeName  : "span"
                        className : "breadcrumb"
                        txt       : "Root"
                        onclick   : ( evt ) =>
                            @load_model_from_breadcrumb 0
                        
                else
                    l = new_dom_element
                        parentNode: @breadcrumb_dom
                        nodeName  : "span"
                        txt       : " > "
                        
                    f = new_dom_element
                        parentNode: @breadcrumb_dom
                        nodeName  : "span"
                        className : "breadcrumb"
                        txt       : folder.name
                        onclick   : ( evt ) =>
                            @load_model_from_breadcrumb i

            
    load_model_from_breadcrumb: ( ind ) ->
        if ind != -1
            @delete_breadcrumb_from_index ind
            if ind == 0
                @model = @breadcrumb[ 0 ]
            else
                @breadcrumb[ ind ]._ptr.load ( m, err ) =>
                    @model = m
        
    delete_breadcrumb_from_index: ( index ) ->
        for i in [ @breadcrumb.length-1 ... index ]
            @breadcrumb.pop()
    
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
        if @use_manage
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
    # following is commented because it doesn't sort item that are pasted
#         c = 0
#         d = 0
#         if b.data instanceof Directory
#             c = 1
#         if a.data instanceof Directory
#             d = 1
#         if d - c != 0
#             return 1
        if a.name.get().toLowerCase() > b.name.get().toLowerCase() then 1 else -1
    
    init: ->
#         console.log "---"
        _sorted = @model.sorted sort_dir
        @index_sorted.clear()
        sorted = new Array
#         alert @display
        if @display == "all"
          for elem, i in _sorted
#             if elem._info.model_type.get() != "Session"
#               alert elem._info.model_type
              sorted.push elem
              @index_sorted.push i
        else if @display == "Session"
          for elem, i in _sorted
            if elem._info.model_type.get() == "Session" or elem._info.model_type.get() == "Directory"
#               alert elem._info.model_type
              sorted.push elem
              @index_sorted.push i
        
#         console.log "init ",@model
#         console.log "sorted ",sorted

#         if @breadcrumb.length > 1
#             parent = new File Directory, ".."
#             sorted.unshift parent
        @allow_shortkey = true
        
        for elem, i in sorted
#             if not elem.name.get().match( /^\./)
#             if not (elem.name.get().match( /^__/) and elem.name.get().match( /__$/))
                do ( elem, i ) =>
                    file_container = new_dom_element
                        parentNode: @all_file_container
                        nodeName  : "div"
                        className : "file_container"
                        
                        ondragstart: ( evt ) =>
                            if document.getElementById('popup_closer')?
                                @popup_closer_zindex = document.getElementById('popup_closer').style.zIndex
                                document.getElementById('popup_closer').style.zIndex = -1
                            
                            @drag_source = []
                            @drag_source = @selected_file.slice 0
                            if parseInt(@selected_file.indexOf i) == -1
                                @drag_source.push i
                            
                            evt.dataTransfer.effectAllowed = if evt.ctrlKey then "copy" else "move"
                            console.log @drag_source.get(), @selected_file
                            evt.dataTransfer.setData 'text/plain', @selected_file.get()
                            
                            
                        ondragover: ( evt ) =>
                            return false
                            
                        ondragend: ( evt ) =>
                            if document.getElementById('popup_closer')?
                                document.getElementById('popup_closer').style.zIndex = @popup_closer_zindex
                        
                        ondrop: ( evt ) =>
                            # drop file got index = i
                            if sorted[ i ]._info.model_type.get() == "Directory"
    #                             if sorted[ i ].name == ".."
    #                                 @breadcrumb[ @breadcrumb.length - 2 ].push sorted[ ind ]
    #                             else
                                    # add selected children to target directory
                                for ind in @drag_source.get()
                                    # sorted[ ind ] is the drop file source
                                    # sorted[ i ]   is the drop file target
                                    if sorted[ ind ] == sorted[ i ]
                                        return false
                                        
                                    sorted[ i ]._ptr.load ( m, err ) =>
                                        m.push sorted[ ind ]
                                            
                                # remove selected children from current directory
                                for sorted_ind in @drag_source.get()
                                    index = @search_ord_index_from_id sorted_ind
                                    @model.splice index, 1
        
                                @selected_file.clear()
                            else
                                evt.stopPropagation()
                                evt.preventDefault()
                                @handle_files evt.dataTransfer.files
                                
                            @cancel_natural_hotkeys evt
                            
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
                    
                                
                    # show correct icon/preview
                    if elem._info.img?
                        picture_container = new_dom_element
                            parentNode: file_container
                            nodeName  : "span"
                            ondblclick: ( evt ) =>
                                @open sorted[ i ], @path()
                                @cancel_natural_hotkeys evt
                            style:
                                maxWidth: 100
                                height  : 100
                                display : "inline-block"
                                
                        @picture = new_dom_element
                            parentNode: picture_container
                            className : "picture"
                            nodeName  : "img"
                            src       : elem._info.img.get()
                            alt       : elem.name.get()
                            title     : elem.name.get()
                            style:
                                maxWidth : 100
                                maxHeight: 100
                                
                                
                    else if elem._info.icon?
                        
    #                     alert (elem._info.model_type)
                        @picture = new_dom_element
                            parentNode: file_container
                            className : "picture" + " " + "icon_" + elem._info.icon.get() + "_128"
                            title     : elem.name.get()
                            ondblclick: ( evt ) =>
                                @open sorted[ i ], @path()
                                @cancel_natural_hotkeys evt
                            width     : 100
                            height    : 100
                                
                    else
                        @picture = new_dom_element
                            parentNode: file_container
                            nodeName  : "img"
                            src       : "img/unknown.png"
                            alt       : ""
                            title     : "" 
                            ondblclick: ( evt ) =>
                                @open sorted[ i ], @path()
                                @cancel_natural_hotkeys evt
                            
                    # stext write percent uploading
                    stext = ""
                    if elem._info?.remaining?.get()
                        r = elem._info.remaining.get()
                        u = elem._info.to_upload.get()
                        stext += " (#{ ( 100 * ( u  - r ) / u ).toFixed( 0 ) }%)"
                    
                    
                    
                    #Show file name
                    text = new_dom_element
                        parentNode: file_container
                        className : "linkDirectory"
                        nodeName  : "div"
                        txt       : elem.name.get() + stext
                        onclick: ( evt ) =>
                            @rename_file text, sorted[ i ]                    
                    
                    #button line              
                    button_line = new_dom_element
                        parentNode: file_container
                        className : "line_button"
                        nodeName  : "div"                    

                    #share button
                    if @use_share
                        share_button = new_dom_element
                            parentNode: button_line
                            className : "share_button"
                            nodeName  : "div"
                            alt       : "Share"
                            title     : "Share"
                            onclick: ( evt ) =>
                                @share_popup evt, elem, elem.name.get()
                    
                    #download button
                    if @use_download
                        if elem._info.model_type.get() == "Session" or elem._info.model_type.get() == "Directory"
                            #nothing to do
                        else
                            download_button = new_dom_element
                                parentNode: button_line
                                className : "download_button"
                                nodeName  : "div"
                                alt       : "Download"
                                title     : "Download"
                                onclick: ( evt ) =>
                                    if elem instanceof TiffFile
                                        elem.load_tiff ( model, err ) =>
                                            # console.log model
                                            if Path? and ( model instanceof Path )
                                                evt.preventDefault()
                                                window.open "/sceen/_?u=" + model._server_id, "_blank"                                
                                    else
                                        elem.load ( model, err ) =>
                                            # console.log model
                                            if Path? and ( model instanceof Path )
                                                evt.preventDefault()
                                                window.open "/sceen/_?u=" + model._server_id, "_blank"
                                            else
                                                alert "TODO: download models"


                
                    
                    
                        
    #                 else if elem._info.model_type.get() == "Img"
    #                     @picture = new_dom_element
    #                         parentNode: file_container
    #                         className : "picture"
    #                         nodeName  : "img"
    #                         src       : elem.data._name
    #                         alt       : ""
    #                         title     : elem.data._name
    #                         ondblclick: ( evt ) =>
    #                             @open sorted[ i ], @path()
    #                             @cancel_natural_hotkeys evt
    #                             
    #                     text = new_dom_element
    #                         parentNode: file_container
    #                         className : "linkDirectory"
    #                         nodeName  : "div"
    #                         txt       : elem.name.get() + stext
    #                         onclick: ( evt ) =>
    #                             @rename_file text, sorted[ i ]
    #                 
    #                 else if elem._info.model_type.get() == "Mesh"
    #                     @picture = new_dom_element
    #                         parentNode: file_container
    #                         nodeName  : "img"
    #                         src       : "img/unknown.png"
    #                         alt       : ""
    #                         title     : ""
    #                         ondblclick: ( evt ) =>
    #                             @open sorted[ i ], @path()
    #                             @cancel_natural_hotkeys evt
    #                             
    #                             
    #                     text = new_dom_element
    #                         parentNode: file_container
    #                         className : "linkDirectory"
    #                         nodeName  : "div"
    #                         txt       : elem.name.get() + stext
    #                         onclick: ( evt ) =>
    #                             @rename_file text, sorted[ i ]
    #                             
    #                 else if elem._info.model_type.get() == "Directory"
    #                     @picture = new_dom_element
    #                         parentNode: file_container
    #                         nodeName  : "img"
    #                         src       : "img/orange_folder.png"
    #                         alt       : elem.name
    #                         title     : elem.name
    #                         ondblclick: ( evt ) =>
    #                             @open sorted[ i ], @path()
    #                             @cancel_natural_hotkeys evt
    #                             
    #                     text = new_dom_element
    #                         parentNode: file_container
    #                         className : "linkDirectory"
    #                         nodeName  : "div"
    #                         txt       : elem.name.get() + stext
    #                         onclick: ( evt ) =>
    #                             @rename_file text, sorted[ i ]
            
        if @use_breadcrumb
            @draw_breadcrumb()
        
        # use for dropable area
        bottom = new_dom_element
            parentNode: @all_file_container
            nodeName  : "div"
            style:
                clear: "both"

                
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

        fs.load "/" + login, ( home, err ) ->
            if err
                return alert "Please enter a valid login (email adress --)"
            fs.load_or_make_dir "/" + login + "/inbox", ( inbox, err ) ->
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
        
    @add_action_2: ( model_type, fun ) ->
        if not ModelEditorItem_Directory._action_list_2[ model_type ]?
            ModelEditorItem_Directory._action_list_2[ model_type ] = []
        ModelEditorItem_Directory._action_list_2[ model_type ].push fun
        
        
    

# registering
ModelEditorItem.default_types.unshift ( model ) -> ModelEditorItem_Directory if model instanceof Directory
