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



# -> creates a tree item with buttons to add new attributes and children
class TreeItem_Parametric extends TreeItem
    constructor: ->
        super()
        
        @add_attr
            _class_export_name: "Item"
            _class_export_language: "JavaScript"
            _class_export_state: false
        
    display_context_actions: ->
        contex_action = new Lst
        contex_action.push  new TreeAppAction_Save
        contex_action.push  new TreeAppAction_AddModel
        @display_suppl_context_actions(contex_action)
        return contex_action        
            