class TreeAppApplication_TreeItemParametric extends TreeAppApplication
    constructor: ->
        super()
        
        @name = 'TreeItem Parametric'
        @powered_with    = 'SpinalCom'
        @description = 'Insert a new TreeItem Parametric in the session.'
            
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
            
        @actions.push
            txt: "TreeItem Parametric"
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                treeItem = @add_item_depending_selected_tree app.data, TreeItem_Parametric, (object) =>
                    name = prompt "Enter the name of the TreeItem:"
                    if name
                        object._name.set name
                    else
                        object._name.set "Item"
        
        
            