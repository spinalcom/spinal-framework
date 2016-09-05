# Copyright 2015 SpinalCom  www.spinalcom.com
# Copyright 2013 Jeremie Bellec
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
class CollectionTreeItem extends TreeItem
    constructor: ->
        super()

        @add_attr
            _collection_size : 0
            _incr_id_collection_child: 0
    
        @bind =>
            if  @_collection_size.has_been_modified()
                @change_collection()
    
    display_suppl_context_actions: ( context_action )  ->
        #function to overload by adding additionnal actions in context actions
    
    
    display_context_actions: ->
        contex_action = new Lst
        contex_action.push  new TreeAppAction_Save
        contex_action.push  
            txt: "add"
            ico: "img/add.png"
            fun: ( evt, app ) =>
                #alert "add material"
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    item._collection_size.set(item._collection_size.get() + 1)
                    
        contex_action.push 
            txt: "remove"
            ico: "img/remove.png"
            fun: ( evt, app ) =>
                #alert "remove material"
                items = app.data.selected_tree_items
                for path_item in items
                    item = path_item[ path_item.length - 1 ]
                    item._collection_size.set(item._collection_size.get() - 1) if item._collection_size.get() > 0
        
        @display_suppl_context_actions(contex_action)
        return contex_action
        
    
    ask_for_id_collection_child: ->
        id_child = parseInt(@_incr_id_collection_child)
        @_incr_id_collection_child.set (parseInt(@_incr_id_collection_child) + 1)
        return id_child
    
    remove_collection_item: ->
        # function to overload 
        size_splice = @_children.length - @_collection_size
        #for num_c in [ @_collection_size ... @_children.length ]
        #    @_children[num_c].clear()
        @_children.splice @_collection_size, size_splice
    
    add_collection_item: ->
        # function to overload 
        id_child = @ask_for_id_collection_child()
        name_temp = "child_" + id_child.toString()
        @add_child  (new BoundaryConditionItem name_temp, id_child, @_dim)
    
    change_collection:  ->
        #modification of the collection size
        size_splice = 0
        if @_children.length > @_collection_size
            @remove_collection_item()
            
        else 
            size_child0_child = @_children.length
            for num_c in [ size_child0_child ... @_collection_size ]
                @add_collection_item()
    
    