class TreeAppModule_Download extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Download'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        # download a file on harddrive
        @actions.push
            txt: "Download result files"
            ico: "img/upload_icon_3.png"
            fun: ( evt, app ) =>  
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    if item._files_to_save? and item._names_to_save?
                        for i in [ 0 ... item._files_to_save.length ]
                            evt.preventDefault()
                            link = document.createElement('a')
                            document.body.appendChild(link);
                            link.download = item._names_to_save[i]
                            link.href = "/sceen/_?u=" + item._files_to_save[i]._server_id
                            link.click()
               
        # add a file on the is-sim desk       
        @actions.push
            txt: "Add result files on the is-sim desk"
            ico: "img/upload_icon_2.png"
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    if FileSystem? and FileSystem.get_inst()? and item._files_to_save? and item._names_to_save?
                        fs = FileSystem.get_inst()
                        dir_save = FileSystem._home_dir + "/__files__"
                        fs.load_or_make_dir dir_save, ( d, err ) =>
                            for i in [ 0 ... item._files_to_save.length ]
                                d.add_file item._names_to_save[i], item._files_to_save[i], model_type: "Path"
                            alert "Files saved on the is-sim desk!"
                                