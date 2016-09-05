class TreeAppApplication_ZigBeeNetwork extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'ZigBee Network'
        @powered_with    = 'Spinalcom'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
        
        @actions.push
            ico: "img/devices_button.png"
            siz: 1
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                ConnectedDevices = @add_item_depending_selected_tree app.data, ZigbeeNetwork
