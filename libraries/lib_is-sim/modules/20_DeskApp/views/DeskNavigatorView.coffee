# Copyright 2015 SpinalCom  www.spinalcom.com
# Copyright 2014 Jeremie Bellec
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
class DeskNavigatorView extends View
    constructor: ( @el, @tree_app, params = {} ) ->        
        @app_data = @tree_app.data
        
        super @app_data
        
        @icon_container = new_dom_element
            nodeName  : "div"
            parentNode: @el
            style      :
                padding    : "0 0 0 0"
    
        
    onchange: ->
        if @app_data.selected_list_desk_items.has_been_directly_modified
            while @icon_container.firstChild?
                @icon_container.removeChild @icon_container.firstChild
            
            block = new_dom_element
                parentNode : @icon_container
                nodeName   : "span"
                
            selected_list_desk_items = if @app_data.selected_list_desk_items[0]._ref? then @app_data.selected_list_desk_items[0]._ref.get() else @app_data.selected_list_desk_items[0]._name.get()
            
#             console.log selected_list_desk_items
#             console.log @app_data.selected_list_desk_items[0]._ref.get()
#             console.log @app_data.selected_list_desk_items[0]._name.get()
            
            #alert @app_data.selected_list_desk_items[0]._name.get()
            if selected_list_desk_items == "Projects"
                Projects_dir = FileSystem._home_dir + "/__projects__"
                fs = @get_fs_instance()
                fs.load_or_make_dir Projects_dir, ( current_dir, err ) ->
                    test = new ModelEditorItem_Project
                          el             : block 
                          model          : current_dir
            
            
            
#                 fs = @get_fs_instance()
#                 DeskNavigatorView.new_project_button block, this
# 
#                 fs.load_or_make_dir FileSystem._home_dir, ( session_dir, err ) ->
#                     test = new ModelEditorItem_Directory
#                           el             : block
#                           model          : session_dir
#                           use_icons      : false
#                           use_upload     : false
#                           use_breadcrumb : false
#                           display        : "Session" 
#                           
#                 ModelEditorItem_Directory.add_action "Session", ( file, path, browser ) ->
#                           console.log file._ptr
#                           myWindow = window.open '',''
#                           myWindow.document.location = "lab.html#" + encodeURI( "#{FileSystem._home_dir}/#{file.name.get()}" )
#                           myWindow.focus()
            
            else if selected_list_desk_items == "Files"
                fs = @get_fs_instance()
                File_dir = FileSystem._home_dir + "/__files__" 
                #alert  FileSystem._home_dir
                fs.load_or_make_dir File_dir, ( session_dir, err ) ->
                    test = new ModelEditorItem_Directory
                          el             : block
                          model          : session_dir
                          use_icons      : true
                          use_upload     : true
                          use_breadcrumb : true
                          use_use        : false
                          display        : "all" 
                          
            else if selected_list_desk_items == "OrganisationFiles"
                fs = @get_fs_instance()
                 
                #alert  FileSystem._home_dir
                #console.log @app_data.config.selected_organisation[0].name.get()
                Organisation_dir = @app_data.config.selected_organisation[0].directory
                
                test = new ModelEditorItem_Directory
                      el             : block
                      model          : Organisation_dir
                      use_icons      : true
                      use_upload     : true
                      use_breadcrumb : true
                      use_use        : false                          
                      display        : "all" 
            
            
            else if selected_list_desk_items == "Organisations"
                Organisation_dir = FileSystem._home_dir + "/__organisations__"
                config = @app_data.config
                fs = @get_fs_instance()
                fs.load_or_make_dir Organisation_dir, ( current_dir, err ) ->
                    test = new ModelEditorItem_Organisation
                          el             : block 
                          model          : current_dir
                          config         : config
                          
            
            else if selected_list_desk_items == "Applications"
                application_list = new ModelEditorItem_Application
                    el             : block 
                    model          : @app_data.config.selected_organisation[0].list_applications
                    use_icons      : true
                    config         : @app_data.config

            else if @selected_list_desk_items == "Admin"
                DeskNavigatorView.new_admin_button block, this
                admin_list = new ModelEditorItem_User
                    el             : block 
                    model          : @app_data.config.selected_organisation[0].admin_users
                    
            else if selected_list_desk_items == "Users"
                DeskNavigatorView.new_users_button block, this
                user_list = new ModelEditorItem_User
                    el             : block 
                    model          : @app_data.config.selected_organisation[0].list_users
                    
      
    
    
    get_fs_instance: ( ) =>
        if FileSystem? and FileSystem.get_inst()?
            fs = FileSystem.get_inst()
            return fs
        else
            fs = new FileSystem
            FileSystem._disp = false
            return fs
    
    
    @new_users_button: ( block, dnv ) ->
        div_top = new_dom_element
            parentNode: block
            className : "desk_panel_title"
        
        new_dom_element
            parentNode: div_top
            nodeName: "div"
            txt: "Users" 
            style:
                margin: "5px 20px 0px 0px"
                height: "30px"
                cssFloat : "left"
    
    
    @new_admin_button: ( block, dnv ) ->
        div_top = new_dom_element
            parentNode: block
            className : "desk_panel_title"
        
        new_dom_element
            parentNode: div_top
            nodeName: "div"
            txt: "Admin users" 
            style:
                margin: "5px 20px 0px 0px"
                height: "30px"
                cssFloat : "left"
    

                
    

   