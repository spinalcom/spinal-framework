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
class LoginBar extends View
    constructor: ( @el, @config ) ->
        super @config
        @edit_view = new UserEditView
        
        @he = new_dom_element
            parentNode: @el
            nodeName   : "div"
            style:
                position: "absolute"
                left    : 0
                right   : 0
                top     : "0px"
                height  : "30px"
                withd   : "100%"
                borderBottom : "1px solid grey" #"#4dbce9"
    
    onchange: () -> 
        if @config.has_been_modified
            while @he.firstChild?
                @he.removeChild @he.firstChild
            
            logo_div = new_dom_element
                parentNode: @he
                nodeName   : "div"
                className  : "logo"
            
            
#################  Decomment to add organisation and user infos  ##################
#             logout_div = new_dom_element
#                 parentNode: @he
#                 nodeName   : "div"
#                 className  : "logout_div"
#                 onmousedown: ( evt ) =>
#                     $.removeCookie("password", { path: '/' })
#                     window.location = "login.html"
#             
#             user_div = new_dom_element
#                 parentNode: @he
#                 nodeName   : "div"
#                 className  : "user_icon_div"
#                 txt        : @config.account.email
#                 style:
#                     height  : "25px"
#                     padding : "5px 0 0 27px"
#                     lineHeight : "23px"
#                     fontSize   : "14px"
#                     textAlign  : "left"
#                     cursor : "pointer"
#                 onmousedown: ( evt ) =>
#                     @edit_view.edit_user evt
#             
#             
#             organisation_div = new_dom_element
#                 parentNode: @he
#                 nodeName   : "div"
#                 className  : "organisation_icon_div"
#                 txt        : if (@config.selected_organisation[0] instanceof Organisation) then @config.selected_organisation[0].name else "Select your organisation"
#                 style:
#                     height  : "25px"
#                     padding : "5px 0 0 25px"
#                     lineHeight : "23px"
#                     fontSize   : "14px"
#                     textAlign  : "left"
#                     cursor : "pointer"
#                 onmousedown: ( evt ) =>
#                     myWindow = window.open '',''
#                     myWindow.document.location = "organisation.html"
#                     myWindow.focus()  
#######################################################################################
                