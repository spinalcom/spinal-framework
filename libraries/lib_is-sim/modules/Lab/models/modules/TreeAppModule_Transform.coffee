class TreeAppModule_Transform extends TreeAppModule
    constructor: ->
        super()
        
        transf = ''
        
        @name = 'Transformation'
        
        @actions.push
            ico: "img/transform_48.png"
            siz: 2
            txt: "Start making transformation"
            fun: ( evt, app ) =>
                #
                app.undo_manager.snapshot()
                selected_items = app.data.get_selected_tree_items()
                transf = @add_item_depending_selected_tree app.data, TransformItem
                @child_in_selected app, TransformItem, selected_items, transf
                
                
        @actions.push
            ico: "img/node_add_24.png"
            siz: 1
            txt: "Add a transformation node"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                canvas = app.selected_canvas_inst()[ 0 ].div
                #if we click on ico
                if evt.clientY < get_top( canvas )
                    p = [ 0, 0, 0 ]
                else
                    pos_x = evt.clientX - get_left( canvas )
                    pos_y = evt.clientY - get_top ( canvas )
                    p = app.selected_canvas_inst()[ 0 ].cm.cam_info.sc_2_rw.pos pos_x, pos_y
                 

                selected_items = app.data.get_selected_tree_items()                
                transf = @add_item_depending_selected_tree app.data, TransformItem
                @child_in_selected app, TransformItem, selected_items, transf
                
                # inverse transform position for origin (old_point)
                
                for transf in app.data.get_selected_tree_items() when transf instanceof TransformItem
                    trans = [ 0, 0, 0 ]
                    p_cur = p
                    if transf.transform.cur_points.length >= 1
                        trans = Vec_3.sub transf.transform.cur_points[ 0 ].pos, transf.transform.old_points[ 0 ].pos
                        p_cur = Vec_3.sub p, trans
                        
                    transf.transform.cur_points.push p
                    transf.transform.old_points.push p_cur
                
        
        @actions.push
            ico: "img/node_del_24.png"
            siz: 1
            txt: "Remove a transformation node"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                cam_info = app.selected_canvas_inst()[ 0 ].cm.cam_info                    
                for transf in app.data.get_selected_tree_items() when transf instanceof TransformItem
                    if transf.transform.cur_points.length > 0
                        selected_point = transf.transform._selected
                        if selected_point.length > 0
                            for i in [ selected_point.length-1..0 ]                    
                                app.undo_manager.snapshot()
                                transf.transform.cur_points.splice( selected_point[ i ], 1 )
                                transf.transform.old_points.splice( selected_point[ i ], 1 )
