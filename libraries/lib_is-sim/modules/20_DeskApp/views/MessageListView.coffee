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
class MessageListView extends View
    constructor: ( @el, @tree_app, params = {} ) ->        
        @app_data = @tree_app.data
        super @app_data
        
        @icon_container = new_dom_element
            nodeName  : "div"
            #parentNode: @el
#             style      :
#                 padding    : "5 0 0 20px"
        
    
    onchange: ->
        if @app_data.list_desk_items.has_been_directly_modified
            @el.appendChild @icon_container
            while @icon_container.firstChild?
                @icon_container.removeChild @icon_container.firstChild
            
            div_top = new_dom_element
                parentNode: @icon_container
                className : "desk_panel_title"
            
            new_dom_element
                parentNode: div_top
                nodeName: "div"
                txt: "Messages" 
                style:
                    margin: "5px 20px 0px 0px"
                    height: "30px"
                    cssFloat : "left"            
            
            new_dom_element
                parentNode: div_top
                nodeName: "button"
                className : "desk_panel_button"
                txt: "New message" 
                style:
                    margin: "3px 0px 0px 0px"
                    padding: "0px 10px 0px 10px"
                    height: "20px"
                    cssFloat : "left"
                onclick: ( evt ) ->
                    name = prompt "Message name", ""
                    if name != ""
                        message = new MessageCollection name
                        fs.load_or_make_dir Message_dir, ( current_dir, err ) ->
                            current_dir.add_file name, message, model_type: "Message"#, icon: "message" 
                    else
                        alert "you must type a name !"
                        
            block = new_dom_element
                parentNode : @icon_container
                nodeName   : "span"
            
            if FileSystem? and FileSystem.get_inst()?
                fs = FileSystem.get_inst()
            else
                fs = new FileSystem
                FileSystem._disp = false
            
            Message_dir = FileSystem._home_dir + "/__messages__"

            #MessageListView.display_messages @model, block
            
            fs.load_or_make_dir Message_dir, ( current_dir, err ) -> 
                test = new ModelEditorItem_Message
                      el             : block
                      model          : current_dir 
        
#         fs.load_or_make_dir Message_dir, ( current_dir, err ) -> 
#             MessageListView.display_messages current_dir, block
    
    
    @display_messages: ( current_dir, block ) ->
        for mes in current_dir
            message_line = new_dom_element
                parentNode: block
                nodeName  : "div"
                style:
                    width: "100%"
                    
                onclick: ( evt ) ->
                    mes.load ( object, err ) =>
                        mv = new MessageView object, evt
                    
            message_name = new_dom_element
                parentNode: message_line
                nodeName  : "div"
                txt : mes.name
                style:
                    margin: "0px 0px 0px 10px"
        