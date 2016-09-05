#
class FieldSetsDataItem extends TreeItem
    constructor: ( name = "FieldSets data" ) ->
        super()
        
        @add_attr

        @_name.set name
        @_viewable.set false
       
        
    accept_child: ( ch ) ->
        ch instanceof FileItem or
        ch instanceof FieldSetFileItem

    add_child: ( child ) ->
        if child instanceof FileItem
            new_file_item = new FieldSetFileItem child._file
            new_file_item._name =  child._name
            @_children.push new_file_item        
