class TreeAppModule_Mesher extends TreeAppModule
    constructor: ->
        super()
        
        @mesher = ''
        @name = 'Mesher'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id

        @actions.push
            ico: "img/point_mesher_remove_24.png"
            siz: 1
            txt: "Remove a mesher point"
            fun: ( evt, app ) =>
                if @mesher?
                    cam_info = app.selected_canvas_inst()[ 0 ].cm.cam_info
                    if @mesher?.p_mesher?.length > 0
                        for ind in [ @mesher.p_mesher.length - 1 .. 0 ]
                            pm = @mesher.p_mesher[ ind ]
                            if pm._selected.indexOf(pm.point) >= 0
                                @mesher.remove_point pm
        
        @actions.push
            ico: "img/point_mesher_add_24.png"
            siz: 1
            txt: "Add a mesher point"
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
                @mesher = @add_item_depending_selected_tree app.data, MesherItem
                pm = new PointMesher p
                @mesher.add_point pm
        
            