# Copyright 2015 SpinalCom  www.spinalcom.com
#  
#
# This file is part of SpinalCore.
#
# Soda is free software: you can redistribute it and/or modify
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



#
class TreeAppModule_Projects extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Projects'
        @visible = false
                

        @actions.push
            ico: "img/proprietes-session-icone-5116-128.png"
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
                 
                dir = FileSystem._home_dir
                  
                #alert dir
                fs.load_or_make_dir dir, ( session_dir, err ) =>     
                    t = new Directory

                    div_top = new_dom_element
                        parentNode: @d
                        style:
                            width: "90%"
                            padding: "10px 20px 10px 20px"
                            height: "50px"
                            #background: "#e5e5e5"
                                              
                    # NEW SESSION
                    button_new = new_dom_element
                        nodeName: "button"
                        txt: "New project"
                        parentNode: div_top
                        onclick: ( evt ) ->
                            clear_page()
                            name = prompt "Project name", "project " + new Date()
                            # name = "session " + new Date()
                            td = new_session()
                            
                            session_dir.add_file name, td, model_type: "Session", icon: "session"
                            window.location = "#" + encodeURI( "#{dir}/#{name}" )   
                    
                    
                    
#                   RELOAD
                    ModelEditorItem_Directory.add_action "Session", ( file, path, browser ) ->
                        file.load ( object, err ) =>
                            clear_page()
                            window.location = "#" + encodeURI( "#{dir}/#{file.name.get()}" )    
                    
                    item_cp = new ModelEditorItem_Directory
                        el          : @d
                        model       : session_dir
                        initial_path: dir
                        use_icons      : false
                        use_upload     : false
                        use_breadcrumb : false
                        display        : "Session" 
                
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
