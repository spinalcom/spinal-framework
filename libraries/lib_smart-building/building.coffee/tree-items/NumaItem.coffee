#
class NumaItem extends TreeItem
    constructor: ( name = "Numa" ) ->
        super()

        @_name.set name
        @_viewable.set false
        
        @add_attr
            name : @_name
            data_visualization : new Choice( 0, ["Selection", "Construction", "Fire Detection"] )

        @bind =>
            if @data_visualization.has_been_modified() or @_children.has_been_modified()
                for floor in @_children
                    floor._data_visualization.num.set @data_visualization.num.get()
                    for flat in floor._children
                        flat._data_visualization.num.set @data_visualization.num.get()
        

    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push  new TreeAppModule_Numa
   
    accept_child: ( ch ) ->
        ch instanceof FloorItem


