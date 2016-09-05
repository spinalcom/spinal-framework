#
class TreeAppAction_AddModel extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'AddModel'

        add_sub =
            fa : "fa-database"
            txt: "Add new model"
            sub:
                prf: "list"
                act: [ ]
        @actions.push add_sub


        # create a new attribute
        add_sub.sub.act.push 
            txt: "Add an attr"
            txtico: "New attr"
            loc: true
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    item = path[ path.length - 1 ]
                container_global = new_dom_element
                    className : "apps_container"
                    id        : "id_apps_container"
                form = new ModelEditorItem_NewAttr
                    el: container_global 
                    model: item
                @newSmallPopup "New Attribute", container_global, evt, app
             
             
        # create a new child
        add_sub.sub.act.push 
            txt: "Add a child"
            txtico: "New child"
            loc: true
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    item = path[ path.length - 1 ]
                container_global = new_dom_element
                    className : "apps_container"
                    id        : "id_apps_container"
                form = new ModelEditorItem_NewTreeItem
                    el: container_global 
                    model: item          
                @newSmallPopup "New TreeItem", container_global, evt, app


        # generate JavaScript file of a new class
        add_sub.sub.act.push
            txt: "Generate a new JavaScript class"
            txtico: "New class"
            loc: true
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    item = path[ path.length - 1 ]
                container_global = new_dom_element
                    className : "apps_container"
                    id        : "id_apps_container"
                form = new ModelEditorItem_NewClass
                    el: container_global 
                    model: item          
                @newSmallPopup "New Class", container_global, evt, app
                
                
                    
    newSmallPopup: ( name, container_global, evt, app ) ->
        inst = undefined
        for inst_i in app.selected_canvas_inst()
            inst = inst_i
        
        if (inst.divCanvas)?
            Ptop   = @getTop( inst.div ) + 50
            Pleft  = @getLeft( inst.div ) + 50
            Pwidth = 220
            Pheight = 132
        else
            Ptop   = 100
            Pleft  = 100
            Pwidth = 220 
            Pheight = 132
        
        p = new_popup name, event: evt, child: container_global, top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, onclose: =>
            @onPopupClose( app )
        app.active_key.set false          


    onPopupClose: ( app ) =>
        document.onkeydown = undefined
        app.active_key.set true
    
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
                        
                        
                        
                        
                    
                    

                    


                               