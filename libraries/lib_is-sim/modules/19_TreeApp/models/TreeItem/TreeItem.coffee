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
class TreeItem extends Model
    constructor: ->
        super()

        @add_attr
            _ico       : ""
            _name      : ""
            _children  : []
            _output    : []
            _viewable  : 0 # eye
            _allow_vmod: true # autorise check/uncheck view
            _name_class: ""
            _context_modules   : new Lst
            _context_actions  : new Lst
        
            
    add_context_modules: ( context_module ) ->
        @_context_modules.push context_module
        
    add_context_actions: ( context_action ) ->
        @_context_actions.push context_action
          
    display_suppl_context_actions: ( context_action )  ->
        #function to overload by adding additionnal actions in context actions
    
    display_context_actions: ->
        contex_action = new Lst
        contex_action.push  new TreeAppAction_Save
        @display_suppl_context_actions(contex_action)
        return contex_action
    
    # child must be an instance of TreeItem
    add_child: ( child ) ->
        @_children.push child

    # remove child, by ref or by num
    rem_child: ( child ) ->
        if child instanceof TreeItem
            for num_c in [ 0 ... @_children.length ]
                if @_children[ num_c ] == child
                    @_children.splice num_c, 1
                    return
        else
            @_children.splice child, 1
    
    detect_child: ( f ) ->
        for i in @_children
            if f i
                return i
        return undefined
    
    # child must be an instance of TreeItem
    add_output: ( child ) ->
        @_output.push child

    # remove child, by ref or by num
    rem_output: ( child ) ->
        if child instanceof TreeItem
            for num_c in [ 0 ... @_output.length ]
                if @_output[ num_c ] == child
                    @_output.splice num_c, 1
                    return
        else
            @_output.splice child, 1
        
    draw: ( info ) ->
        if @sub_canvas_items?
            for s in @sub_canvas_items()
                s.draw info
            
    anim_min_max: ->
 
    z_index: ->
        0
        
    to_string: ->
        @_name.get()
        
