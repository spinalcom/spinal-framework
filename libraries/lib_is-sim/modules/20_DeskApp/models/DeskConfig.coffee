# Copyright 2015 SpinalCom  www.spinalcom.com
# Copyright 2014 Jeremie Bellec
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
class DeskConfig extends Model
    constructor: ->
        super()
        @add_attr
            name  :  "configuration desk"
            list_desk_items         : new Lst # root items 
            selected_list_desk_items: new Lst # path list
            account                 : new UserModel
            list_contact            : new Lst
            selected_organisation   : new Lst
            selected_site           : new Lst
            
        @list_desk_items.push new DeskItem "Files", "Files" 
        @list_desk_items.push new DeskItem "Projects", "Projects"
        #@list_desk_items.push new DeskItem "Applications"
#         @list_desk_items.push new DeskItem "Organisations", "Organisations"
#         @list_desk_items.push new DeskItem "Sites", "Sites"
        
        @selected_list_desk_items.push @list_desk_items[0]
        
        
            
            
            
            
            