# Copyright 2015 SpinalCom  www.spinalcom.com
#
# This file is part of SpinalCore.
#
# SpinalCore is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class DirectoryFieldSetCorreliItem extends TreeItem
    constructor: (name = 'FieldSet directory') ->
        super()
        
        @_name.set name
#         @_ico.set "img/krita_16.png"
        @_viewable.set true
        
        @add_attr
            reference_image : new ConstrainedVal( 0, { min: 0, max: 20, div: 0 } )
            visualization: new FieldSet
            _current_reference : -1
            _directory : new directory
#             _app_data : ""
#             _current_img : ""
        
        
    accept_child: ( ch ) ->
        ch instanceof FileItem
    

    draw: ( info ) ->  
        if @_children.length > 0
            @reference_image.set_params 
                max:  @_children.length - 1
            if @_current_reference.get() != @reference_image.get()
                @_current_reference.set @reference_image.get()
            
                if @_children[ @_current_reference ]?
                    @_current_img = @_children[ @_current_reference ]._name.get()
                    @_children[ @_current_reference ]._file.load ( res, err ) =>
                        test = new Img res
                        @img = test 
                        info.cm.origin()
                        
    sub_canvas_items: ->
        [ @visualization ] 

#                     
#     is_app_data: ( item ) ->
#         if item instanceof TreeAppData
#             return true
#         else
#             return false
        
#     get_app_data: ->
#         #get app_data
#         it = @get_parents_that_check @is_app_data
#         return it[ 0 ]
#    

#     draw_old: ( info ) ->        
#         current_step = info.time
#         if info.time >= @_children.length
#             current_step = @_children.length - 1
#         
#         #
#         if @_children[ current_step ]?
#             if @_children[ current_step ]._name.get() != @_current_img
# #                 console.log @_children[ current_step ]._name.get()
# #                 console.log @_current_img
#                 @_current_img = @_children[ current_step ]._name.get()
#                 @_children[ info.time ]._file.load ( res, err ) =>
#                     test = new Img res
#                     @img = test 
# #                     app_data = @get_app_data()
#                     path_temp = @_app_data.selected_tree_items[0]
#                     @_app_data.selected_tree_items.clear()
#                     @_app_data.selected_tree_items.push path_temp
# #                     @select_item app_data, @_children[ current_step ], @_children[ current_step ]
#                     info.cm.origin()
# #                     app_data.watch_item @_children[ current_step ]
# #                     app_data.selected_tree_items.clear()
# #                     app_data.selected_tree_items.push @_children[ info.time ]

#     select_item: ( app_data, item, parent ) ->
#         if !parent
#             path = []
#             path.push app_data.selected_session()
#         else
#             path = app_data.get_root_path_in_selected parent
#         path.push item
#         app_data.selected_tree_items.clear()
#         app_data.selected_tree_items.push path
    
    
#     z_index: ->
#         return 0
    

    
        
