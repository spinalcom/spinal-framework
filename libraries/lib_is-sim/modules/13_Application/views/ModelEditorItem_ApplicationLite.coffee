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
class ModelEditorItem_ApplicationLite extends ModelEditorItem
    # @see add_action
        # others type can be added by other files

    constructor: ( params ) ->
        super params
        @use_icons      = if params.use_icons? then params.use_icons else true
        
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
        
        if @use_icons
            ModelEditorItem_Application.new_application_button this
        
        @all_file_container = new_dom_element
                parentNode: @container
                nodeName  : "div"

                
                
#     @new_application_button: ( this_instance ) ->
#         div_top = new_dom_element
#             parentNode: this_instance.container
#             className : "desk_panel_title"
#         
#         new_dom_element
#             parentNode: div_top
#             nodeName: "div"
#             txt: "Application" 
#             style:
#                 margin: "5px 20px 0px 0px"
#                 height: "30px"
#                 cssFloat : "left"
#         
#         new_dom_element
#             parentNode: div_top
#             nodeName: "button"
#             className : "desk_panel_button"
#             txt: "New application" 
#             style:
#                 margin: "3px 0px 0px 0px"
#                 padding: "0px 10px 0px 10px"
#                 height: "20px"
#                 cssFloat : "left"
#             onclick: ( evt ) ->
#                 this_instance.new_application evt
    
    
#     new_application: ( evt ) =>
#         @d = new_dom_element
#             className : "apps_container"
#             id        : "id_apps_container"
#     
#         application_list = new ModelEditorItem_Application
#             el             : @d 
#             model          : APPS
#             use_icons      : false 
#             add_app        : true
#             config         : @config
#                     
#                  
#         Ptop   = 100
#         Pleft  = 100
#         Pwidth = 800 
#         Pheight = 500 
#                 
#         p = new_popup "Apps store", event: evt, child: @d, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, onclose: =>
#             @onPopupClose( @d )
        
        
    onPopupClose: ( div_to_clear ) =>
        document.onkeydown = undefined
        @clear_page(div_to_clear)
    
    clear_page: ( div_to_clear ) ->
        while div_to_clear.firstChild?
            div_to_clear.removeChild div_to_clear.firstChild  
    
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
        
        for application, i in sorted
            do ( application, i ) =>
                if application.actions?
                    group_app = new_dom_element
                        parentNode: @all_file_container
                        className : "app_group"
                        nodeName  : "div"
        #             group_name = new_dom_element
        #                 parentNode: group_app
        #                 className : "app_group_name"
        #                 nodeName  : "div"
        #                 txt       : application.name
                    for act in application.actions
                        ico_app = new_dom_element
                            parentNode: group_app
                            className : "app_icon"
                            nodeName  : "div"
                        if @app? and @use_in_lab?
                            app = @app
                            ico_app.onmousedown = ( evt ) =>
                                act.fun evt, app
#                       
                        else if @config? and @add_app?
                            config = @config
                            ico_app.onmousedown = ( evt ) =>
                                # see if the application allready exist
                                exist = false
                                for a in config.selected_organisation[0].list_applications
                                    for ac in a.actions
                                        if ac.ico == act.ico
                                            exist = true
                                        
                                if not exist
                                    config.selected_organisation[0].list_applications.push application
                
#                             else
#                                 alert "no app"
#                                 onmousedown: ( evt ) =>
#                                     fs = new FileSystem
#                                     name = prompt "Project name", "Project" + new Date()
#                                     td = @new_session()
#                                     fs.load_or_make_dir FileSystem._home_dir, ( session_dir, err ) ->
#                                         session_dir.add_file name, td, model_type: "Session", icon: "session"
#                                         #window.location = "lab.html#" + encodeURI( "#{home_dir}/#{name}" )
#                                     myWindow = window.open '',''
#                                     myWindow.document.location = "lab.html#" + encodeURI( "#{FileSystem._home_dir}/#{name}" )
#                                     myWindow.focus()

                        picture = new_dom_element
                            parentNode: ico_app
                            className : "app_picture"
                            nodeName  : "img"
                            src       : "img/button.png"
                            alt       : act.txt
                            title     : act.txt
                            style:
                                position: "absolute"
                                zIndex: 1
                                maxWidth : 150
                                maxHeight: 75
                        
                        name_app = new_dom_element
                            parentNode: ico_app
                            className : "app_group_title"
                            nodeName  : "div"
                            txt       : application.name    
                            style:
                                position: "absolute"
                                zIndex: 2
                                
                        text_app = new_dom_element
                            parentNode: group_app
                            className : "app_group_text"
                            nodeName  : "div"
                        
#                         name_app = new_dom_element
#                             parentNode: text_app
#                             className : "app_group_title"
#                             nodeName  : "div"
#                             txt       : application.name
                        
                        editor_app = new_dom_element
                            parentNode: text_app
                            className : "app_group_name"
                            nodeName  : "div"
                            style:
                                fontWidth : 0.8
                            txt       : "powered by"
                        
                        powered_app = new_dom_element
                              parentNode: text_app
                              className : "app_group_name"
                              nodeName  : "div"
                              txt       : application.powered_with
                        
                        description_app = new_dom_element
                              parentNode: group_app
                              className : "app_group_text"
                              nodeName  : "div"
                              txt       : application.description
                        
    path: ->
        "test_need_to_be_complete"  
        
    
#     @add_action: ( model_type, fun ) ->
#         if not ModelEditorItem_Directory._action_list[ model_type ]?
#             ModelEditorItem_Directory._action_list[ model_type ] = []
#         ModelEditorItem_Directory._action_list[ model_type ].push fun
        
        
    
