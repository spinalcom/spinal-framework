# Copyright 2015 SpinalCom  www.spinalcom.com
# Copyright 2014 jeremie Bellec
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

class MessageView extends View
    constructor: ( model, evt ) ->
        @user_email = Cookies.set("email")
        super model
        @model = model
        
        @container_global = new_dom_element
            id : "list_message_container"
            nodeName   : "div"
            style:
                overflowY: "hidden"
                overflowX: "hidden"
                #backgroundColor : "#ffffff"
        
        Ptop   = 100
        Pleft  = 100
        Pwidth = 400 
        Pheight = 500 
        
        #@myWindow = window.open '_','_blank','width=400,height=500,resizable=1'
        #@myWindow.document.body.appendChild @container_global
        
        p = new_popup "Message", event: evt, child: @container_global, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, background: "#262626",  onclose: =>
            @onPopupClose( )
        
    onchange:()->
        @clear_page(@container_global)
        list_message_container = new_dom_element
            parentNode : @container_global
            nodeName   : "div"
            style:
                cssFloat   : "left"
                width      : "96%"
                margin     : "0px 0 0 0px"
                position   : "absolute"
                bottom     : "120px"
                top        : "40px"
                border     : "1px solid grey"
                #backgroundColor : "#ffffff"
                overflowY: "auto"
        
        @view_model_messages(list_message_container)
        list_message_container.scrollTop = list_message_container.scrollHeight
        
        input_message_container = new_dom_element
            parentNode : @container_global
            nodeName   : "div"
            style:
                cssFloat   : "left"
                width      : "96%"
                height     : "70px"
                margin     : "0px 0 0 0px"
                position   : "absolute"
                bottom     : "40px"
                #border     : "1px solid grey"
                #backgroundColor : "#ffffff"
                
        message_input = new_dom_element
            parentNode : input_message_container
            id : "message_input"
            nodeName   : "input"
            type : "textarea"
            value : @model.text
            style:
                cssFloat   : "left"
                width      : "100%"
                height     : "60px"
                margin     : "5px 0 0 0px"
                border     : "1px solid grey"
                backgroundColor : "#ffffff"
              
        input_message_container = new_dom_element
            parentNode : @container_global
            nodeName   : "button"
            txt : "Post"
            style:
                width      : "96%"
                height     : "30px"
                margin     : "0px 0 0 0px"
                position   : "absolute"
                bottom     : "5px"
                textAlign  : "center"
                #border     : "1px solid grey"
                color      : "#262626"
                cursor     : "pointer"
                background : "#4dbce9"
                
            onclick : ( evt ) =>
                @model.text = message_input.value
                #alert @model.text
                @model.add_message()
                message_input.value = ""
                
        
    onPopupClose: ( ) =>
        document.onkeydown = undefined
        @clear_page(@container_global)
    
    clear_page: ( div_to_clear ) ->
        while div_to_clear.firstChild?
            div_to_clear.removeChild div_to_clear.firstChild
    
    view_model_messages: ( parent ) ->
        for mes in @model.list_messages
            message_container = new_dom_element
                parentNode : parent
                nodeName   : "div"
                style:
                    cssFloat   : "left"
                    width      : "97%"
                    margin     : "5px 0 0 0px"
                    #border     : "1px solid grey"
                    color      : "black"
                    
            user_line = new_dom_element
                parentNode : message_container
                nodeName   : "div"
                style:
                    cssFloat   : "left"
                    width      : "100%"
                    margin     : "0px 0 0 px"
            
            user_container = new_dom_element
                parentNode : user_line
                nodeName   : "div"
                txt : mes.user
                style:
                    cssFloat   : "left"
                    margin     : "0px 0 0 5px"
                    color      : "#4dbce9"
                    
            user_container = new_dom_element
                parentNode : user_line
                nodeName   : "div"
                txt : mes.date
                style:
                    cssFloat   : "right"
                    margin     : "0px 0 0 5px"
                    color      : "#4dbce9"
                    
            text_line = new_dom_element
                parentNode : message_container
                nodeName   : "div"
                style:
                    cssFloat   : "left"
                    width      : "100%"
                    margin     : "5px 0 0 0px"
                    color      : "black"
                    
            text_container = new_dom_element
                parentNode : text_line
                nodeName   : "div"
                txt : mes.text
                style:
                    cssFloat   : "left"
                    margin     : "0px 0 0 5px"
                    color      : "black"
            
    
    
    
 