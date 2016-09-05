#
class FieldSetSetItem extends CollectionTreeItem
    constructor: ( name = "Field collection" ) ->
        super()
        
        # default values
        @_name.set name
#         @_ico.set "img/part_collection.png"
        @_viewable.set false
        
        # attributes
        @add_attr
            visualization: new FieldSet  
   
#         @bind =>
#             if  @_children[0]? and @_children[0].has_been_modified()
#                 @visualization = @_children[0].visualization
#             
#             if  @visualization.has_been_modified() and @_children[0]?
#                 @apply_to_children()
   
   
    apply_to_children:  ->
    
        #alert @_children[0].visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters?
        #alert @_children[0].visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters._legend?
        #alert @_children[0].visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters._legend.max_val
        #alert @_children[2].visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters._legend.max_val
        
#         if @visualization.color_by.lst[@visualization.color_by.num.get()]? 
#           if @visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters?
#             actual_legend = @visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters._legend
#             actual_legend.auto_fit.set false
#             
#             for i in [ 1 ... @_children.length ]
#                 @_children[i].visualization.warp_factor.set  @visualization.warp_factor.get()
#                 @_children[i].visualization.warp_by.num.set  @visualization.warp_by.num.get()
#                 @_children[i].visualization.color_by.set  @visualization.color_by.num.get()
#                 
#                 temp_legend = @_children[i].visualization.color_by.lst[@visualization.color_by.num.get()].drawing_parameters._legend
#                 temp_legend.max_val.set actual_legend.max_val.get()
#                 temp_legend.min_val.set actual_legend.min_val.get()
#                 temp_legend.auto_fit.set false
#                 temp_legend.show_legend.set false
#                 temp_legend.color_map = actual_legend.color_map
#                 
   
    accept_child: ( ch ) ->
        ch instanceof FieldSetItem
    
    display_context_actions: ->
        contex_action = new Lst
        contex_action.push  new TreeAppAction_Save
        return contex_action
    
    add_collection_item: ->
        # function to overload 
        #alert "test"
        id_child = @ask_for_id_collection_child()
        name_temp = "field_" + id_child.toString()
        @add_child  (new FieldSetItem name_temp, id_child)
    