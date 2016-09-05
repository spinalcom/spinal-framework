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
# SpinalCore is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with SpinalCore. If not, see <http://www.gnu.org/licenses/>.



#

class UserEditView extends View
    constructor: ( ) ->
        @user_email = Cookies.set("email")
    
    edit_user: ( evt ) =>
        @edit_user_div = new_dom_element
            id        : "edit_user_container"
        
        Ptop   = 100
        Pleft  = 100
        Pwidth = 800 
        Pheight = 320 
        
        @container_list_action_div = new_dom_element
            parentNode: @edit_user_div
            className : "edit_user_container"
            nodeName   : "div"
            style:
                cssFloat   : "left"
                height     : 220
                width      : 200
                margin     : "8px 0 0 10px"
                #border     : "1px solid grey"
            
        @edit_user_information_div = new_dom_element
            parentNode: @edit_user_div
            nodeName   : "div"
            style:
                cssFloat   : "left"
                height     : 220
                width      : 560
                margin     : "0px 0 0 0px"
                #border     : "1px solid grey"
        
        UserEditView.get_user_information( this )
        #@edit_user_information()
        
        p = new_popup "Account information", event: evt, child: @edit_user_div, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, background: "#262626",  onclose: =>
            @onPopupClose( )

    
        
    edit_user_information: ( ) =>  
        @clear_page(@edit_user_information_div)
        list = ["email"]
        list_value = [@user_email]
        for name,j in list
            @affich_information(name, list_value[j], @edit_user_information_div)
            
        #         link_modifie_informations = new_dom_element
        #             parentNode : @edit_user_information_div
        #             nodeName   : "div" 
        #             txt     : "Change information"
        #             style      :
        #                 height     : 20
        #                 width      : 150
        #                 margin     : "15px 0 0 60px"
        #                 cssFloat      : "right"
        #                 fontSize   : "15px"
        #                 color      : "#4dbce9"
        #                 cursor     : "pointer"
        #             onmousedown: ( evt ) =>
        #                 @change_information()
                
        link_change_password = new_dom_element
            parentNode : @edit_user_information_div
            nodeName   : "div" 
            txt     : "Change password"
            style      :
                height     : 20
                width      : 150
                margin     : "15px 0 0 30px"
                cssFloat      : "right"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
            onmousedown: ( evt ) =>
                @change_password()
                
        @affich_pwscomment(@edit_user_information_div)     
         
    
    change_information: ( ) =>
        @clear_page(@edit_user_information_div)
        list = ["email"]
        list_id = ["email"]
        list_value = [@user_email]
        for name,j in list
            @modifie_information(name, list_id[j], list_value[j], @edit_user_information_div)
            
        link_modifie_informations = new_dom_element
            parentNode : @edit_user_information_div
            nodeName   : "button" 
            txt     : "Valid"
            className  : "user_line"
            style      :
                height     : 40
                width      : 100
                border     : "none"
                margin     : "15px 0 0 10px"
                cssFloat      : "right"
                fontSize   : "18px"
                color      : "#262626"
                cursor     : "pointer"
                background : "#4dbce9"
            onmousedown: ( evt ) =>
                UserEditView.get_change_user_information this 
                
        link_change_password = new_dom_element
            parentNode : @edit_user_information_div
            nodeName   : "button" 
            txt     : "Cancel"
            className  : "user_line"
            style      :
                height     : 40
                width      : 100
                border     : "none"
                margin     : "15px 0 0 10px"
                cssFloat      : "right"
                fontSize   : "18px"
                color      : "#262626"
                cursor     : "pointer"
                background : "#4dbce9"
            onmousedown: ( evt ) =>
                @edit_user_information()
                
        @affich_pwscomment(@edit_user_information_div)
                
                
    change_password: ( ) =>
        @clear_page(@edit_user_information_div)
        list = ["Current password","New password","Confirme password"]
        list_id = ["password","new_password","confirme_password"]
        for name, j in list
            @modifie_information(name, list_id[j], "", @edit_user_information_div, "password")
            
        link_modifie_informations = new_dom_element
            parentNode : @edit_user_information_div
            nodeName   : "button" 
            txt     : "Valid"
            className  : "user_line"
            style      :
                height     : 40
                width      : 100
                border     : "none"
                margin     : "15px 0 0 10px"
                cssFloat      : "right"
                fontSize   : "18px"
                color      : "#262626"
                cursor     : "pointer"
                background : "#4dbce9"
            onmousedown: ( evt ) =>
                UserEditView.get_change_user_password this 
                
        link_change_password = new_dom_element
            parentNode : @edit_user_information_div
            nodeName   : "button" 
            txt     : "Cancel"
            className  : "user_line"
            style      :
                height     : 40
                width      : 100
                border     : "none"
                margin     : "15px 0 0 10px"
                cssFloat      : "right"
                fontSize   : "18px"
                color      : "#262626"
                cursor     : "pointer"
                background : "#4dbce9"
            onmousedown: ( evt ) =>
                @edit_user_information()
                
        @affich_pwscomment(@edit_user_information_div)
                
    affich_pwscomment: ( parent_div ) =>            
        container_comment = new_dom_element
            parentNode : parent_div
            nodeName   : "div" 
            id         : 'pwscomment'
            style      :
                width      : "100%"
                height     : 30
                border     : "none"
                fontSize   : "20px"
                cssFloat   : "left"
                margin     : "10px 0 0 0px"
                textAlign  : "center"
                color : "red"   
            
    affich_information: ( name, txt_value, parent_div ) =>
        line_div = new_dom_element
            parentNode: parent_div
            nodeName   : "div"
            className  : "user_line"
            style : 
                cssFloat   : "left"
                height     : 40
                width      : "100%"
                fontSize   : "18px"
                background : "#262626"
                margin     : "10px 0 0 0px"
        
        name_div = new_dom_element
            parentNode: line_div
            nodeName   : "div"
            txt : name + " : "
            style : 
                cssFloat   : "left"
                height     : 30
                width      : 200
                margin     : "10px 0 0 10px"
                
        value_div = new_dom_element
            parentNode: line_div
            nodeName   : "div"
            txt : txt_value
            style : 
                cssFloat   : "left"
                height     : 30
                margin     : "10px 0 0 0px"
                fontWeight : "bold"
                
    modifie_information: ( name, input_id, txt_value = "", parent_div, input_type = "text" ) =>
        line_div = new_dom_element
            parentNode: parent_div
            nodeName   : "div"
            className  : "user_line"
            style : 
                cssFloat   : "left"
                height     : 40
                width      : "100%"
                fontSize   : "18px"
                background : "#262626"
                margin     : "10px 0 0 0px"
        
        name_div = new_dom_element
            parentNode: line_div
            nodeName   : "div"
            txt : name + " : "
            style : 
                cssFloat   : "left"
                height     : 30
                width      : 200
                margin     : "10px 0 0 10px"
                
        value_div = new_dom_element
            parentNode: line_div
            nodeName   : "input"
            type       : input_type
            id   : input_id
            value : txt_value
            style : 
                cssFloat   : "left"
                height     : 30
                width      : 300
                margin     : "5px 0 0 0px"
                fontWeight : "bold"        
    
    
    onPopupClose: ( ) =>
        document.onkeydown = undefined
        @clear_page(@edit_user_div)
    
    clear_page: ( div_to_clear ) ->
        while div_to_clear.firstChild?
            div_to_clear.removeChild div_to_clear.firstChild
            
    
    
    @get_user_information: ( user ) ->
        email = Cookies.set("email")
        password = Cookies.set("password")
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                if user_id > 0
                    user.edit_user_information() 
                else
                    document.getElementById( 'pwscomment' ).innerHTML = "You need to log in" if document.getElementById( 'pwscomment' )       
        xhr_object.send() 
        
        
    @get_change_user_information: ( user ) ->
        email = Cookies.set("email")
        password = Cookies.set("password")
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                alert user_id
                if user_id > 0
                    user.user_email = "modified email"
                    user.edit_user_information()
                    document.getElementById( 'pwscomment' ).innerHTML = "Your informations have been modified" if document.getElementById( 'pwscomment' )
                    document.getElementById( 'pwscomment' ).style.color = "green" if document.getElementById( 'pwscomment' )
                else
                    document.getElementById( 'pwscomment' ).innerHTML = "You need to log in" if document.getElementById( 'pwscomment' ) 
                
        xhr_object.send() 
        
        
    @get_change_user_password: ( user ) ->
        email = Cookies.set("email")
        old_password = document.getElementById( 'password' ).value
        new_password = document.getElementById( 'new_password' ).value
        confirmed_password = document.getElementById( 'confirme_password' ).value

        if old_password == Cookies.set("password") and new_password == confirmed_password
            xhr_object = FileSystem._my_xml_http_request()
            xhr_object.open 'GET', "get_change_user_password?e=#{encodeURI email}&op=#{encodeURI old_password}&np=#{encodeURI new_password}&cp=#{encodeURI confirmed_password}", true
            xhr_object.onreadystatechange = ->
                if @readyState == 4 and @status == 200
                    lst = @responseText.split " "
                    user_id = parseInt lst[ 0 ]
                    if user_id > 0
                        Cookies.set( "password", new_password, {expires:7} )
                        user.edit_user_information()
                        document.getElementById( 'pwscomment' ).innerHTML = "Your password have been modified" if document.getElementById( 'pwscomment' )
                        document.getElementById( 'pwscomment' ).style.color = "green" if document.getElementById( 'pwscomment' )
                    else
                        user.edit_user_information()
                        document.getElementById( 'pwscomment' ).innerHTML = "You need to log in" if document.getElementById( 'pwscomment' )  
            xhr_object.send()
        else
            document.getElementById( 'pwscomment' ).innerHTML = "confirmed password do not match !" if document.getElementById( 'pwscomment' )  
    
    
    
    
    
    
 