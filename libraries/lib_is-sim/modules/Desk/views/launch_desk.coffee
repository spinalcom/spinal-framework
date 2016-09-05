#clear page
USER_EMAIL = ""

load_if_cookie_desk = () ->
    if Cookies.set("email") and Cookies.set("password")
        email = Cookies.set("email")
        password = Cookies.set("password")
        USER_EMAIL = email
        
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "../get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                lst = @responseText.split " "
                user_id = parseInt lst[ 0 ]
                if user_id > 0
                    launch_desk user_id, decodeURIComponent lst[ 1 ].trim()
                else
                     window.location = "login.html"     
                    
                
        xhr_object.send()
          
    else   
        window.location = "login.html"       
    
        
# launch_desk = ( userid, home_dir, main = document.body ) ->
launch_desk = ( main = document.body ) ->
    MAIN_DIV = main
    
    #load or create config file
    FileSystem._home_dir = "__users__/root"
    FileSystem._userid   = if USER? and USER.userid? then USER.userid else "1657"
    FileSystem._password = if USER? and USER.password? then USER.password else "4YCSeYUzsDG8XSrjqXgkDPrdmJ3fQqHs"
    bs = new BrowserState
    fs = new FileSystem
    config_dir = FileSystem._home_dir + "/__config__" 
    
    fs.load_or_make_dir config_dir, ( current_dir, err ) ->
        config_file = current_dir.detect ( x ) -> x.name.get() == ".config"
        if not config_file?
            config  = new DeskConfig
            current_dir.add_file ".config", config, model_type: "Config"
            create_desk_view config, main

        else
            config_file.load ( config, err ) =>
                create_desk_view config, main
  
    
create_desk_view = ( config, main = document.body ) ->
    #login bar
    login_bar = new LoginBar main, config
    
    #desk
    dd = new DeskData  config  
    app = new DeskApp main, dd  
    
    


