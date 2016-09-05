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
class TreeAppModule_File extends TreeAppModule
    constructor: (params = {})->
        super()
        
        @name = if params.name? then params.name else 'Files'
        @home_dir = if params.home_dir? then params.home_dir else undefined
        @use_icons   = if params.use_icons? then params.use_icons else true
        @use_upload  = if params.use_upload? then params.use_upload else true
        @use_manage  = if params.use_manage? then params.use_manage else true
        @use_share   = if params.use_share? then params.use_share else false
        @use_download= if params.use_download? then params.use_download else false
        
        @visible = true
                

        @actions.push
            ico: "img/dossier-gris-icone-7749-32.png"
            siz: 0.9
            txt: "Open in Tree"
            fun: ( evt, app ) =>
                @d = new_dom_element
                    className : "browse_container"
                    id        : "id_browse_container"
                
                if FileSystem? and FileSystem.get_inst()?
                    fs = FileSystem.get_inst()
                else
                    fs = new FileSystem
                    FileSystem._disp = false
                 
                dir = if @home_dir? then @home_dir else FileSystem._home_dir + "/__files__"
                  
                #alert dir
                fs.load_or_make_dir dir, ( d, err ) =>     
#                     t = new Directory

#                     d.add_file "My first directory", t
#                     d.add_file "composite01.png", ( new Img 'composite01.png' ), model_type: "Img"
#                     t.add_file "Steel", ( new Directory )
#                     t.add_file "Steel", ( new Lst [ 1, 2 ] )
#                     d.add_file "Mesh", ( new Lst [ 1, 2 ] ), model_type: "Mesh"
#                     d.add_file "Work", ( new Lst [ 1, 2 ] )

                        
                    ModelEditorItem_Directory.add_action "Mesh", ( file, path, browser ) =>
                        console.log "open mesh"
                        if TreeAppModule_Sketch? and app?
                            modules = app.data.modules
                            for m in modules
                                if m instanceof TreeAppModule_Sketch
                                    m.actions[ 4 ].fun evt, app, file
                                    
                    #                     ModelEditorItem_Directory.add_action "Img", ( file, path, browser ) ->
                    #                         if TreeAppModule_ImageSet? and app?                            
                    #                             # Check if file is an ImgItem, otherwise, try to build it
                    #                             if file not instanceof ImgItem
                    #                                 if file instanceof Img
                    #                                     file = new ImgItem img, app
                    #                                 else if file instanceof File
                    #                                     if FileSystem? and FileSystem.get_inst()?
                    #                                         fs = FileSystem.get_inst()
                    #                                         fs.load img, ( m, err ) ->
                    #                                             file = file#TODO, use ptr to build real ImgItem
                    #                                 else
                    #                                     return                                    
                    #                                     
                    #                             @modules = app.data.modules
                    #                             for m in @modules
                    #                                 if m instanceof TreeAppModule_ImageSet
                    #                                     m.actions[ 1 ].fun evt, app, file
                     
                    ModelEditorItem_Directory.add_action "TreeItem", ( file, path, browser ) => 
                        file.load ( object, err ) =>
                            app.undo_manager.snapshot()
#                             copyItem = object.deep_copy()
#                             copyItem._name.set (object._name + "_copy")
                            session = app.data.selected_session()
                            session.add_child object
                            
                            @select_item app.data, object
                            @watch_item app.data, object
                            
                            #session.add_child copyItem
                            #@select_item app.data, copyItem
                            #@watch_item app.data, copyItem
                    
                                    
                    ModelEditorItem_Directory.add_action "Path", ( file, path, browser ) =>
                        file.load ( m, err ) =>
                            # if file.name.get()
#                           #if name end like a picture (png, jpg, tiff etc)
                            if file.name.ends_with( ".raw" )
                                rv = @add_item_depending_selected_tree app.data, RawVolume
                                rv._children.push new FileItem file
                            else if file.name.ends_with( ".unv" ) or file.name.ends_with( ".csv" ) or file.name.ends_with( ".geo" ) or file.name.ends_with( ".stp" )
                                file_item = new FileItem file
                                for item in app.data.get_selected_tree_items()
                                    if item.accept_child? file_item
                                        item.add_child file_item
                                        done = true
                                if not done
                                    alert "Please select in the tree an item which accepts a file"
                                #rv = @add_item_depending_selected_tree app.data, nf
                            else if file.name.ends_with( ".jpg" ) or file.name.ends_with( ".png" ) or file.name.ends_with( ".tiff" ) or file.name.ends_with( ".tif" ) or file.name.ends_with( ".jpeg" )
                                img_item = new ImgItem m, app # "/sceen/_?u=" + m._server_id
                                img_item._name.set file.name
                                # @add_item_depending_selected_tree app_data, CorrelationItem
                                done = false
                                for item in app.data.get_selected_tree_items()
                                    if item.accept_child? img_item
                                        item.add_child img_item
                                        done = true
                                if not done
                                    alert "Please select in the tree an item which accepts an image"
                                
                            else 
                                file_item = new FileItem file
                                for item in app.data.get_selected_tree_items()
                                    if item.accept_child? file_item
                                        item.add_child file_item
                                        done = true
                                if not done
                                    alert "Please select in the tree an item which accepts a file"
                                #@modules = app.data.modules
                                #for m in @modules
                                #    if m instanceof TreeAppModule_ImageSet
                                #        m.actions[ 1 ].fun evt, app, img_item
                    
                    
                    
                    
                    ModelEditorItem_Directory.add_action_2 "Mesh", ModelEditorItem_Directory._action_list["Mesh"][0]
                    ModelEditorItem_Directory.add_action_2 "TreeItem", ModelEditorItem_Directory._action_list["TreeItem"][0]
                    ModelEditorItem_Directory.add_action_2 "Path", ModelEditorItem_Directory._action_list["Path"][0]
                    
                    ModelEditorItem_Directory.add_action_2 "Directory", ( file, path, browser ) => 
                        file.load ( m, err ) =>
                            done = false
                            for elem, i in m
                                if elem.name.ends_with( ".jpg" ) or elem.name.ends_with( ".png" ) or elem.name.ends_with( ".tiff" ) or elem.name.ends_with( ".tif" ) or elem.name.ends_with( ".jpeg" )
                                    
                                    file_item = new FileItem elem
                                    for item in app.data.get_selected_tree_items()
                                        if item.accept_child? file_item
                                            item.add_child file_item
                                            if not done
                                                elem.load ( res, err ) =>
                                                    img_temp = new Img res
                                                    item.img = img_temp
                                            done = true
                                else if elem.name.ends_with( ".raw" )
                                    file_item = new RawVolume
                                    file_item._children.push new FileItem elem
                                    for item in app.data.get_selected_tree_items()
                                        if item.accept_child? file_item
                                            item.add_child file_item
                                            done = true         
                                                
                            if not done 
                                alert "No image can be found in this directory"
                    
                    item_cp = new ModelEditorItem_Directory
                        el          : @d
                        model       : d
                        initial_path: dir
                        use_icons   : @use_icons
                        use_upload  : @use_upload
                        use_manage  : @use_manage
                        use_share   : @use_share
                        use_download: @use_download
                        
                
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
                
                #alert "ok"
                
                p = new_popup "Browse Folder", event: evt, child: @d, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, onclose: =>
                    @onPopupClose( app )
                app.active_key.set false
                
#             key: [ "Shift+O" ]


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
    
    onPopupClose: ( app ) =>
        document.onkeydown = undefined
        app.active_key.set true
