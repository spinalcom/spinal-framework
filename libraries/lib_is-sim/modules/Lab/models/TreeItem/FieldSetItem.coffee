#
class FieldSetItem extends TreeItem
    constructor: ( name = "Field", id_c = 0 ) ->
        super()
        
        # default values
        @_name.set name
#         @_ico.set "img/part_collection.png"
        @_viewable.set true
        
        # attributes
        @add_attr
            id : id_c
            visualization: new FieldSet
        
   
    accept_child: ( ch ) ->
        false
    
    sub_canvas_items: ->
        res = [@visualization]
        return res