class TreeAppModule_AddEmployee extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'AddEmployee'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        @actions.push
            txt: "Ajouter une directrice"
            ico: "img/team.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    team = path[ path.length - 1 ]
                    if team instanceof eTeamItem 
                    
                        names_list = [ "Clemence", "Marianne", "Julie", "Jeromine", "Sebastienne", "Kevina" ]
                        rand_name = Math.floor(Math.random() * names_list.length)                        
                        rand_floor = Math.floor(Math.random() * 6)
                        if rand_floor <= 4
                            rand_space = Math.floor(Math.random() * 5)
                        else if rand_floor == 5
                            rand_space = Math.floor(Math.random() * 4)
                        else
                            rand_space = Math.floor(Math.random() * 1)
                        
                        employee = new eEmployeeItem 
                            name: names_list[ rand_name ]
                            id: (team._children.length).toString()
                            role: 0
                        team.add_child employee
                        app.data.watch_item employee

        @actions.push
            txt: "Ajouter un operateur"
            ico: "img/team.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    team = path[ path.length - 1 ]
                    if team instanceof eTeamItem 
                    
                        names_list = [ "Jean", "Robert", "Pierre", "Paul", "Jacques", "Jeremie", "Sebastien", "Julien", "Audrey", "Clement", "Mariano", "Clemence", "Marianne", "Julie", "Andrew", "Jeromine", "Sebastienne", "Kevin", "Kevina" ]
                        rand_name = Math.floor(Math.random() * names_list.length)                        
                        rand_floor = Math.floor(Math.random() * 6)
                        if rand_floor <= 4
                            rand_space = Math.floor(Math.random() * 5)
                        else if rand_floor == 5
                            rand_space = Math.floor(Math.random() * 4)
                        else
                            rand_space = Math.floor(Math.random() * 1)
                        
                        employee = new eEmployeeItem 
                            name: names_list[ rand_name ]
                            id: (team._children.length).toString()
                            role: 1
                        team.add_child employee
                        app.data.watch_item employee
                       
                       
        @actions.push
            txt: "Ajouter un technicien "
            ico: "img/team.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    team = path[ path.length - 1 ]
                    if team instanceof eTeamItem 
                    
                        names_list = [ "Jean", "Robert", "Pierre", "Paul", "Jacques", "Jeremie", "Sebastien", "Julien", "Audrey", "Clement", "Mariano", "Clemence", "Marianne", "Julie", "Andrew", "Jeromine", "Sebastienne", "Kevin", "Kevina" ]
                        rand_name = Math.floor(Math.random() * names_list.length)                        
                        rand_floor = Math.floor(Math.random() * 6)
                        if rand_floor <= 4
                            rand_space = Math.floor(Math.random() * 5)
                        else if rand_floor == 5
                            rand_space = Math.floor(Math.random() * 4)
                        else
                            rand_space = Math.floor(Math.random() * 1)
                        
                        employee = new eEmployeeItem 
                            name: names_list[ rand_name ]
                            id: (team._children.length).toString()
                            role: 2
                        team.add_child employee
                        app.data.watch_item employee                        


        # save on FileSystem
        @actions.push
            txt: "Save team"
            key: [ "" ]
            ico: "img/3floppy-mount-icone-4238-64.png"
            loc: true
            fun: ( evt, app ) =>
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    console.log "saving : ", item
                    alert "Team saved on the Hub!"
                    if FileSystem? and FileSystem.get_inst()?
                        fs = FileSystem.get_inst()
#                         name = prompt "Item name", item.to_string()
                        dir_save = "/__building__"
                        name_save = prompt "Enter the name of your team:", item._name.get()
                        fs.load_or_make_dir dir_save, ( d, err ) =>
                            building_file = d.detect ( x ) -> x.name.get() == name_save
                            if building_file?
                                d.remove building_file
                            d.add_file name_save, item, model_type: "TreeItem"




                               