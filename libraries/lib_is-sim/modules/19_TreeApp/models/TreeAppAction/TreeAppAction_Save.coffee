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



class TreeAppAction_Save extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Save'
        
        save_sub =
            fa : "fa-floppy-o"
            siz: 1
            txt: "Save"
            sub:
                prf: "list"
                act: [ ]
            key: [ "M" ]
        @actions.push save_sub
        
        save_sub.sub.act.push 
            txt: "Save"
            key: [ "" ]
            fa : "fa-floppy-o"
            loc: true
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                #alert "save"
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    console.log "saving : ", item
                    if FileSystem? and FileSystem.get_inst()?
                        fs = FileSystem.get_inst()
                        # we should ask for filename and path
                        #name = item.to_string()
                        name = prompt "Item name", item.to_string() + new Date()
                        dir_save = FileSystem._home_dir
                        dir_save = dir_save + "/__files__"
                        fs.load_or_make_dir dir_save, ( d, err ) =>
                            d.add_file name, item, model_type: "TreeItem"
                
        
        save_sub.sub.act.push 
            txt: "Delete current tree item"
            fa : "fa-trash"
            key: [ "Del" ]
            loc: true
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    #prevent deleting root item (session)
                    if path.length > 1
                        m = path[ path.length - 1 ]
                        if m instanceof DisplaySettingsItem #prevent deleting display settings item
                            return true
                        else if m instanceof ViewItem
                            modules = app.data.modules
                            for mod in modules 
                                if mod instanceof TreeAppModule_PanelManager
                                    mod.actions[ 4 ].fun evt, app
                        else
                            app.undo_manager.snapshot()
                            path[ path.length - 2 ].rem_child m
                            app.data.delete_from_tree m
                            app.data.selected_tree_items.clear()

                
        save_sub.sub.act.push 
            txt: "Copy tree item"
            fa : "fa-copy"
            loc: true
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    #prevent deleting root item (session)
                    if path.length > 1
                        m = path[ path.length - 1 ]
                        if m instanceof DisplaySettingsItem or  m instanceof ViewItem #prevent deleting display settings item
                            # nothing to do
                        else
                            copyItem = m.deep_copy()
                            copyItem._name.set (m._name + "_copy")
                            session = app.data.selected_session()
                            session.add_child copyItem
                            
                            @select_item app.data, copyItem
                            @watch_item app.data, copyItem
