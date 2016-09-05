#
class FieldSetsVisuItem extends TreeItem_Automatic
    constructor: ( fs_data_item, name = "Fields", id_c = 0) ->
        super()
        
        @_name.set name
        @_viewable.set true
        
        # attributes
        @add_attr
            id : id_c
            visualization: new FieldSet
                        
            _fs_data_ptr: new Ptr fs_data_item
            
            #visualization attributes
            _has_result : false
            _old_visualisation_field : ""
            _old_time_step : -1
            time : -1

        @bind =>
            if @_has_result.has_been_modified()
                @draw()

    draw: ( info ) ->
        if @time.val?.has_been_modified() or @_has_result.has_been_modified() or @_viewable.has_been_modified()
            @_fs_data_ptr.load (res, err) =>
                res._children[ @time.get() ]?._fs_ptr.load (res, err) =>
                    for i in [ 0 ... @visualization.color_by.lst.length ]
                        output_data = @visualization.color_by.lst[i].data._data
                        output_data.clear()
                        res_data = res.color_by.lst[i].data._data
                        for j in [ 0 ... res_data.length ]
                            output_data.push res_data[j]
                 
    accept_child: ( ch ) ->
        false
        
    sub_canvas_items: ->
        res = [@visualization]
        return res
        
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "visualization" ] )
   
   