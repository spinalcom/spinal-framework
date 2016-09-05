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
class LoginView extends View
    constructor: ( @el ) ->
        @page_container = new_dom_element
            nodeName  : "div"
            parentNode: @el
              
        @container_bakground = new_dom_element
            parentNode : @page_container
            nodeName   : "div" 
            className  : "LoginBackground"
        
        @create_login_div()
        
#         @container_video = new_dom_element
#             parentNode : @page_container
#             nodeName   : "div" 
#             className  : "LoginBackground"
#             txt        : '<iframe width="560" height="315" src="//www.youtube.com/embed/K1MVV_nG8BI?rel=0" frameborder="0" allowfullscreen></iframe>'
        
        
    
    clear_page: ->
        while @container_bakground.firstChild?
            @container_bakground.removeChild @container_bakground.firstChild
    
    # login  ---------------------------------------------------------------------------------------------   
    create_login_div: ->
        @clear_page()
        
        container_title = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            txt        : "Connect to access your Desk and Lab"
            style      :
                height     : 30
                width      : "100%"
                fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                #border     : "1px solid grey"
                margin     : "20px 0 0 0px"
                cssFloat      : "left"
        
        container_login = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            style      :
                height     : 470
                width      : 600
                #border     : "1px solid grey"
                margin     : "0px 0 0 100px"
                cssFloat      : "left"
    #             fontWeight : "bold"
    #             fontSize   : "20px"
        
        container_div = new_dom_element
            parentNode : container_login
            nodeName   : "div" 
            style      :
                height     : 250
                width      : 600
                margin     : "210px 0 0 0px"
                border     : "1px solid grey"
                cssFloat      : "left"
    #             fontWeight : "bold"
    #             fontSize   : "20px"
        
        name_email = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "email"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
                cssFloat      : "left"
        
        input_email = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            type       : "text"
            id         : "email"
            name       : "email"
    #         value      : "email" 
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
                cssFloat      : "left"
    #         onblur  : ( evt ) => 
    #             this.value = 'email' if this.value == ''
    #         onfocus  : ( evt ) =>
    #             value = "" if value == 'email'
            onkeypress : ( evt ) =>
                @keypresslogin( evt )
        
        name_password = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "password"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
                cssFloat      : "left"
                
        input_password = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            id         : "password"
            type       : "password"
            name       : "password"
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
                cssFloat      : "left"
            onkeypress : ( evt ) =>
                @keypresslogin( evt )
                
        login_button = new_dom_element
            parentNode : container_div
            nodeName   : "button"
            txt     : "Log in"
            style      :
                width      : 300
                height     : 30
                border     : "none"
                fontSize   : "20px"
                margin     : "10px 0 0 150px"
                textAlign  : "center"
                background : "#4dbce9"
                cssFloat      : "left"
            onmousedown: ( evt ) =>
                #alert "login_button"
                @try_username()

        container_comment = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            id         : 'pwscomment'
            style      :
                width      : "100%"
                height     : 30
                border     : "none"
                fontSize   : "15px"
                margin     : "10px 0 0 0px"
                textAlign  : "center"
                cssFloat      : "left"
                color : "red"
                    
        link_new_user = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt     : "New account"
            style      :
                height     : 20
                #width      : 100
                margin     : "10px 0 0 60px"
                cssFloat      : "left"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
    #             border     : "1px solid grey"
            onmousedown: ( evt ) =>
                @create_new_account_div()
                
        link_forgot_password = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt     : "Forgot your password ?"
            style      :
                height     : 20
                #width      : 180
                margin     : "10px 0 0 20px"
                cssFloat   : "left"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
    #             border     : "1px solid grey"
            onmousedown: ( evt ) =>
                @create_lost_password_div()
                
        link_resend_confirmation = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt     : "Resend confirmation instructions"
            style      :
                height     : 20
                #width      : 200
                margin     : "10px 0 0 20px"
                cssFloat   : "left"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
    #             border     : "1px solid grey"
            onmousedown: ( evt ) =>
                @create_confirmation_istructions_div()
     
    # create a new account ---------------------------------------------------------------------------------------------    
    create_new_account_div :  ->
        @clear_page()
        
        container_title = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            txt        : "Create your account to access your online lab"
            style      :
                height     : 30
                width      : "100%"
                fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                #border     : "1px solid grey"
                margin     : "20px 0 0 0px"
                cssFloat      : "left"
        
        container_login = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            style      :
                height     : 470
                width      : 600
                #border     : "1px solid grey"
                margin     : "0px 0 0 100px"
                cssFloat      : "left"
                background : "#262626"
    #             fontWeight : "bold"
    #             fontSize   : "20px"
        
        container_div = new_dom_element
            parentNode : container_login
            nodeName   : "div" 
            style      :
                height     : 320
                width      : 600
                margin     : "140px 0 0 0px"
                border     : "1px solid grey"
                cssFloat      : "left"
    #             fontWeight : "bold"
    #             fontSize   : "20px"
        #email
        name_new_email = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "email"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
        
        input_new_email = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            type       : "text"
            id         : "new_email"
            name       : "new_email"
    #         value      : "Email" 
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
            onkeypress : ( evt ) =>
                @keypress_new_account( evt )
                
        #password 
        name_new_password = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "new password"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
                
        input_new_password = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            type       : "password"
            id         : "new_password"
            name       : "new_password"
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
            onkeypress : ( evt ) =>
                @keypress_new_account( evt )
                
        #confirmed password 
        name_confirmed_password = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "confirmed password"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
                
        input_confirmed_password = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            type       : "password"
            id         : "confirmed_password"
            name       : "confirmed_password"
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
            onkeypress : ( evt ) =>
                @keypress_new_account( evt )
        
        #create new account
        new_account_button = new_dom_element
            parentNode : container_div
            nodeName   : "button"
            id         : "new_account_button"
            txt     : "Create account"
            style      :
                width      : 300
                height     : 30
                border     : "none"
                fontSize   : "20px"
                margin     : "10px 0 0 150px"
                textAlign  : "center"
                cssFloat   : "left"
                background : "#4dbce9"
            onmousedown: ( evt ) =>
                #alert "new_account_button"
                @try_new_account()

        wait_new_account = new_dom_element
            parentNode : container_div
            nodeName   : "div"
            id         : "wait_new_account"
            style      :
                width      : 300
                height     : 40
                border     : "none"
                margin     : "10px 0 0 150px"
                cssFloat   : "left"
                textAlign  : "center"
                
        new_dom_element
            parentNode : wait_new_account
            nodeName   : "div" 
            className  : "Loading"
        
        $("#wait_new_account").hide()
        
        container_comment = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            id         : 'pwscomment'
            style      :
                width      : "100%"
                height     : 30
                border     : "none"
                fontSize   : "15px"
                margin     : "10px 0 0 0px"
                textAlign  : "center"
                cssFloat      : "left"
                color : "red"
                    
        link_login = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt     : "Login page"
            style      :
                height     : 20
                width      : "100%"
                margin     : "10px 0 0 0px"
                cssFloat      : "left"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
                textAlign  : "center"
            onmousedown: ( evt ) =>
                @create_login_div()
                
        
    # lost password ---------------------------------------------------------------------------------------------    
    create_lost_password_div : ->
        @clear_page()
        
        container_title = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            txt        : "Ask for a new password"
            style      :
                height     : 30
                width      : "100%"
                fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                #border     : "1px solid grey"
                margin     : "20px 0 0 0px"
                cssFloat      : "left"
        
        
        container_login = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            style      :
                height     : 470
                width      : 600
                #border     : "1px solid grey"
                margin     : "0px 0 0 100px"
                cssFloat      : "left"
        
        container_div = new_dom_element
            parentNode : container_login
            nodeName   : "div" 
            style      :
                height     : 180
                width      : 600
                margin     : "280px 0 0 0px"
                border     : "1px solid grey"
                cssFloat      : "left"
    #             fontWeight : "bold"
    #             fontSize   : "20px"

        #email
        name_email = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "email"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
        
        input_email = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            type       : "text"
            id         : "email"
            name       : "email"
    #         value      : "Email" 
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
            onkeypress : ( evt ) =>
                @keypress_new_password( evt )
                
        
        #get new password
        new_password_button = new_dom_element
            parentNode : container_div
            nodeName   : "button"
            txt     : "Get your new password"
            id         : "new_password_button"
            style      :
                width      : 300
                height     : 30
                border     : "none"
                fontSize   : "20px"
                margin     : "10px 0 0 150px"
                textAlign  : "center"
                background : "#4dbce9"
                cssFloat      : "left"
            onmousedown: ( evt ) =>
                @try_new_password()

        wait_new_password = new_dom_element
            parentNode : container_div
            nodeName   : "div"
            id         : "wait_new_password"
            style      :
                width      : 300
                height     : 40
                border     : "none"
                margin     : "10px 0 0 150px"
                cssFloat   : "left"
                textAlign  : "center"
                
        new_dom_element
            parentNode : wait_new_password
            nodeName   : "div" 
            className  : "Loading"
        
        $("#wait_new_password").hide()        
                
        container_comment = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            id         : 'pwscomment'
            style      :
                width      : "100%"
                height     : 30
                border     : "none"
                fontSize   : "15px"
                margin     : "10px 0 0 0px"
                textAlign  : "center"
                cssFloat      : "left"
                color : "red"
                    
        link_login = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt     : "Login page"
            style      :
                height     : 20
                width      : "100%"
                margin     : "10px 0 0 0px"
                cssFloat      : "left"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
                textAlign  : "center"
            onmousedown: ( evt ) =>
                @create_login_div()
        
    # resend confirmation instructions ---------------------------------------------------------------------------------------------    
    create_confirmation_istructions_div : ->
        @clear_page()
        
        container_title = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            txt        : "Resend confirmation instructions"
            style      :
                height     : 30
                width      : "100%"
                fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                #border     : "1px solid grey"
                margin     : "20px 0 0 0px"
                cssFloat      : "left"
        
        
        container_login = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            style      :
                height     : 470
                width      : 600
                #border     : "1px solid grey"
                margin     : "0px 0 0 100px"
                cssFloat      : "left"
        
        container_div = new_dom_element
            parentNode : container_login
            nodeName   : "div" 
            style      :
                height     : 180
                width      : 600
                margin     : "280px 0 0 0px"
                border     : "1px solid grey"
                cssFloat      : "left"
    #             fontWeight : "bold"
    #             fontSize   : "20px"

        #email
        name_email = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt        : "email"
            style      :
                width      : "100%"
                height     : 25
    #             fontWeight : "bold"
                fontSize   : "20px"
                textAlign   : "center"
                margin     : "10px 0 0 0px"
        
        input_email = new_dom_element
            parentNode : container_div
            nodeName   : "input"
            type       : "text"
            id         : "email"
            name       : "email"
    #         value      : "Email" 
            style      :
                width      : 300
                height     : 25
                fontSize   : "15px"
                margin     : "10px 0 0 150px"
                textAlign   : "center"
            onkeypress : ( evt ) =>
                @keypress_confirmation_instructions( evt )
                
        
        #get new password
        confirmation_button = new_dom_element
            parentNode : container_div
            nodeName   : "button"
            id         : "confirmation_button"
            txt     : "Get your new password"
            style      :
                width      : 300
                height     : 30
                border     : "none"
                fontSize   : "20px"
                margin     : "10px 0 0 150px"
                textAlign  : "center"
                background : "#4dbce9"
                cssFloat      : "left"
            onmousedown: ( evt ) =>
                @try_confirmation_instructions()
        
        wait_confirmation = new_dom_element
            parentNode : container_div
            nodeName   : "div"
            id         : "wait_confirmation"
            style      :
                width      : 300
                height     : 40
                border     : "none"
                margin     : "10px 0 0 150px"
                cssFloat   : "left"
                textAlign  : "center"
                
        new_dom_element
            parentNode : wait_confirmation
            nodeName   : "div" 
            className  : "Loading"
        
        $("#wait_confirmation").hide()   
        
        container_comment = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            id         : 'pwscomment'
            style      :
                width      : "100%"
                height     : 30
                border     : "none"
                fontSize   : "15px"
                margin     : "10px 0 0 0px"
                textAlign  : "center"
                cssFloat      : "left"
                color : "red"
                    
        link_login = new_dom_element
            parentNode : container_div
            nodeName   : "div" 
            txt     : "Login page"
            style      :
                height     : 20
                width      : "100%"
                margin     : "10px 0 0 0px"
                cssFloat      : "left"
                fontSize   : "15px"
                color      : "#4dbce9"
                cursor     : "pointer"
                textAlign  : "center"
            onmousedown: ( evt ) =>
                @create_login_div() 
     
    #log in function ----------------------------------------------------------------------------------
    try_username : () ->
        email = document.getElementById( 'email' ).value
        password = document.getElementById( 'password' ).value
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                if user_id > 0
                    Cookies.set( "email", email, {expires:7} )
                    Cookies.set( "password", password, {expires:7} )
                    window.location = "desk.html"
                else
                    document.getElementById( 'pwscomment' ).innerHTML = "Wrong email/password" if document.getElementById( 'pwscomment' )
                    
                
        xhr_object.send()
        
        
    
    keypresslogin : ( e ) ->
        if e.which == 13
            @try_username()
        else
            document.getElementById( 'pwscomment' ).innerHTML = "" if document.getElementById( 'pwscomment' )
            
            
            
    #Create a new account ----------------------------------------------------------------------------------    
    try_new_account : () ->
        new_email = document.getElementById( 'new_email' ).value
        new_password = document.getElementById( 'new_password' ).value
        confirmed_password = document.getElementById( 'confirmed_password' ).value
        
# <<<<<<< HEAD
        if new_password != confirmed_password
            return document.getElementById( 'pwscomment' ).innerHTML = "confirmed password do not match !" if document.getElementById( 'pwscomment' )
        if new_email.indexOf( "@" ) <= 0
            return document.getElementById( 'pwscomment' ).innerHTML = "Invalid email !" if document.getElementById( 'pwscomment' )
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "get_new_account?e=#{encodeURI new_email}&p=#{encodeURI new_password}&cp=#{encodeURI confirmed_password}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                if user_id > 0
                    window.location = "desk.html"
                    #launch_ecosystem_mecanic user_id, decodeURIComponent lst[ 1 ].trim()
                    #desk_page user_id, decodeURIComponent lst[ 1 ].trim()
                else
                    document.getElementById( 'pwscomment' ).innerHTML = "Existing user" if document.getElementById( 'pwscomment' )
        xhr_object.send()
# =======
#         if new_password == confirmed_password
#             $("#new_account_button").slideUp( 500 )
#             $("#wait_new_account").slideDown( 500 )
#             
#             xhr_object = FileSystem._my_xml_http_request()
#             xhr_object.open 'GET', "get_new_account?e=#{encodeURI new_email}&p=#{encodeURI new_password}&cp=#{encodeURI confirmed_password}", true
#             xhr_object.onreadystatechange = ->
#                 if @readyState == 4 and @status == 200
#                     lst = @responseText.split " "
#                     user_id = parseInt lst[ 0 ]
#                     if user_id > 0
#                         window.location = "desk.html"
#                         #launch_ecosystem_mecanic user_id, decodeURIComponent lst[ 1 ].trim()
#                         #desk_page user_id, decodeURIComponent lst[ 1 ].trim()
#                     else
#                         $("#new_account_button").slideDown( 500 )
#                         $("#wait_new_account").slideUp( 500 )
#                         document.getElementById( 'pwscomment' ).innerHTML = "Wrong email/password" if document.getElementById( 'pwscomment' )             
#             xhr_object.send()
#         else
#             document.getElementById( 'pwscomment' ).innerHTML = "confirmed password do not match !" if document.getElementById( 'pwscomment' )     
# >>>>>>> ab2126978d309bf75bf7252d4ec0ea9d57784c95
        
    
    keypress_new_account : ( e ) ->
        if e.which == 13
            @try_new_account()
        else
            document.getElementById( 'pwscomment' ).innerHTML = "" if document.getElementById( 'pwscomment' )
            
            
            
    #get a new password ----------------------------------------------------------------------------------    
    try_new_password : () ->
        email = document.getElementById( 'email' ).value
        $("#new_password_button").slideUp( 500 )
        $("#wait_new_password").slideDown( 500 )
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "get_new_password?e=#{encodeURI email}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                $("#new_password_button").slideDown( 500 )
                $("#wait_new_password").slideUp( 500 )
                if user_id > 0
                    document.getElementById( 'pwscomment' ).innerHTML = "We have sent you a mail with your new password" if document.getElementById( 'pwscomment' )
                else
                    document.getElementById( 'pwscomment' ).innerHTML = "Wrong email" if document.getElementById( 'pwscomment' )             
        xhr_object.send()
        
    
    keypress_new_password : ( e ) ->
        if e.which == 13
            @try_new_password()
        else
            document.getElementById( 'pwscomment' ).innerHTML = "" if document.getElementById( 'pwscomment' )     
      
      
    #resend confirmation instructions ----------------------------------------------------------------------------------    
    try_confirmation_instructions : () ->
        email = document.getElementById( 'email' ).value
        $("#confirmation_button").slideUp( 500 )
        $("#wait_confirmation").slideDown( 500 )
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "get_resend_confirmation?e=#{encodeURI email}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                $("#confirmation_button").slideDown( 500 )
                $("#wait_confirmation").slideUp( 500 )
                if user_id > 0
                    document.getElementById( 'pwscomment' ).innerHTML = "We have sent you a mail with your instructions" if document.getElementById( 'pwscomment' )
                else
                    document.getElementById( 'pwscomment' ).innerHTML = "Wrong email" if document.getElementById( 'pwscomment' )                  
        xhr_object.send()
        
    
    keypress_confirmation_instructions : ( e ) ->
        if e.which == 13
            @try_confirmation_instructions()
        else
            document.getElementById( 'pwscomment' ).innerHTML = "" if document.getElementById( 'pwscomment' )     
                       
