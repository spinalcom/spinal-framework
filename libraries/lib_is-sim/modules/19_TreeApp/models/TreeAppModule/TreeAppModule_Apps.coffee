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
class TreeAppModule_Apps extends TreeAppModule
    constructor: (withConfig = true) ->
        super()

        APPS = new Lst
        APPS.push new TreeAppApplication_TreeItemParametric # Apps by default: insertion of TreeItems parametric
        for app in APPLIS
            APPS.push new window[app]()
    
        @name = 'Apps'
        @visible = true
                
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id and 
            app.data.focus.get() != app.treeview.process_id
      
        @icon_app = new Lst
        
        @actions.push
            ico: "img/Apps.png"
            siz: 0.9
            txt: "Load app in tree"
            ina: _ina
            fun: ( evt, app ) =>
                container_global = new_dom_element
                    className : "apps_container"
                    id        : "id_apps_container"
                
                
#                 for appli in app.config.selected_organisation[0].list_applications
#                    @display_app( app, appli ) if appli?
                
################# Decomment the following to use the Organisation process #####################
#                 if withConfig
#                     fs = @get_fs_instance()
#                     config_dir = FileSystem._home_dir + "/__config__" 
#                     
#                     fs.load_or_make_dir config_dir, ( current_dir, err ) ->
#                         config_file = current_dir.detect ( x ) -> x.name.get() == ".config"
#                         config_file.load ( config, err ) =>   
#                             application_list = new ModelEditorItem_Application
#                                 el             : container_global 
#                                 model          : config.selected_organisation[0].list_applications
#                                 use_icons      : false 
#                                 app            : app
#                                 use_in_lab     : true
#                 else
############################################################################################
                application_list = new ModelEditorItem_ApplicationLite
                    el             : container_global 
                    model          : APPS
                    use_icons      : false 
                    app            : app
                    use_in_lab     : true
                 
#                 for i_app in [0 .. APPS.length]
#                    @display_app( app, APPS[i_app] ) if APPS[i_app]?
#                          
                
                inst = undefined
                for inst_i in app.selected_canvas_inst()
                    inst = inst_i
                
                
                if (inst.divCanvas)?
                  Ptop   = @getTop( inst.div )  
                  Pleft  = @getLeft( inst.div )  
                  Pwidth = inst.divCanvas.offsetWidth
                  Pheight = inst.divCanvas.offsetHeight
                  Pheight = Pheight + 22
                
                else
                  Ptop   = 100
                  Pleft  = 100
                  Pwidth = 800 
                  Pheight = 500 
                  
                    #position = inst.div.position()
                    #alert inst.div.offsetLeft + " " + inst.div.offsetTop + " " +  inst.div.offsetHeight + " " + inst.div.offsetWidth
                #alert "top : " + Ptop + " left : " + Pleft + " width : " +  Pwidth + " height : " + Pheight
                
                p = new_popup "My apps", event: evt, child: container_global, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, onclose: =>
                    @onPopupClose( app )
                app.active_key.set false
                
#             key: [ "Shift+O" ]

    onPopupClose: ( app ) =>
        document.onkeydown = undefined
        app.active_key.set true
    
    # obtenir la position réelle dans le canvas
    getLeft: ( l ) ->
      if l.offsetParent?
          return l.offsetLeft + @getLeft( l.offsetParent )
      else
          return l.offsetLeft

    # obtenir la position réelle dans le canvas
    getTop: ( l ) ->
        if l.offsetParent?
            return l.offsetTop + @getTop( l.offsetParent )
        else
            return l.offsetTop
    
    get_fs_instance: ( ) =>
        if FileSystem? and FileSystem.get_inst()?
            fs = FileSystem.get_inst()
            return fs
        else
            fs = new FileSystem
            FileSystem._disp = false
            return fs
        
    display_app: ( app, application ) =>
        if application.actions?
            group_app = new_dom_element
                parentNode: container_global
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
                    onmousedown: ( evt ) =>
                        act.fun evt, app
#                           group_app.classList.toggle "block"
#                     onclick: ( evt ) =>
#                           act.fun( evt, app )
                @picture = new_dom_element
                    parentNode: ico_app
                    className : "app_picture"
                    nodeName  : "img"
                    src       : act.ico
                    alt       : act.txt
                    title     : act.txt
                    style:
                        maxWidth : 150
                        maxHeight: 75
                
                text_app = new_dom_element
                    parentNode: group_app
                    className : "app_group_text"
                    nodeName  : "div"
                
                @name_app = new_dom_element
                    parentNode: text_app
                    className : "app_group_title"
                    nodeName  : "div"
                    txt       : application.name
                
                @editor_app = new_dom_element
                    parentNode: text_app
                    className : "app_group_name"
                    nodeName  : "div"
                    style:
                        fontWidth : 0.8
                    txt       : "powered by"
                
                @powered_app = new_dom_element
                      parentNode: text_app
                      className : "app_group_name"
                      nodeName  : "div"
                      txt       : application.powered_with
                
                link_app = new_dom_element
                    parentNode: group_app
                    className : "app_group_link"
                    nodeName  : "div"
                
                #if application.publication_link? != ""
                @publication_link_app = new_dom_element
                    parentNode: link_app
                    className : "app_group_publication_link"
                    nodeName  : "div"
                    src       : act.ico
                    alt       : "Related publications"
                    title     : "Related publications"
                    onmousedown: ( evt ) =>
                        myWindow = window.open '',''
                        myWindow.document.location.href = application.publication_link
                        myWindow.focus()
                
                @tutorial_link_app = new_dom_element
                    parentNode: link_app
                    className : "app_group_tutorial_link"
                    nodeName  : "div"
                    src       : act.ico
                    alt       : application.tutorial_link
                    title     : "Video tutorial"
                    onmousedown: ( evt ) =>
                        myWindow = window.open '',''
                        myWindow.document.location.href = application.tutorial_link
                        myWindow.focus()

