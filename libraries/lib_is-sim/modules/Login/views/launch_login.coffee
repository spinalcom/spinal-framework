
bs = new BrowserState

#launch login page ------------------------------------------------------------------------------------------------------------    
launch_login = ( userid, home_dir, main = document.body ) ->
    MAIN_DIV = main
    main.style.overflowY = "auto"
    main.style.overflowX = "auto"
    
    login_view = new LoginView main

load_if_cookie_login = () ->
    if Cookies.set("email") and Cookies.set("password")
        email = Cookies.set("email")
        password = Cookies.set("password")
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "../modules/get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                if user_id > 0
                    window.location = "desk.html" 
                else
                    $.removeCookie( "password", { path: '/' })
                    launch_login()
                    document.getElementById( 'pwscomment' ).innerHTML = "Wrong email/password" if document.getElementById( 'pwscomment' )
                    
                
        xhr_object.send()
    
    else if bs.location.hash.get().length > 1 # signe # dans la requette
        hash = bs.location.hash.get()
        confirmationToken = hash.slice 1
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "../get_confirm_new_account?c=#{confirmationToken}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                if user_id > 0
                    launch_login()
                    document.getElementById( 'pwscomment' ).innerHTML = "Your account as been confirmed" if document.getElementById( 'pwscomment' )
                else
                    launch_login()
                    document.getElementById( 'pwscomment' ).innerHTML = "No account to be confirmed" if document.getElementById( 'pwscomment' )
                     
        xhr_object.send()
 
    else
        launch_login()
    