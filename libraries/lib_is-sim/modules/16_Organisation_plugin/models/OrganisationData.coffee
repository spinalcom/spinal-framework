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
class OrganisationData extends Model 
    constructor: (config) ->
        super()
        @add_attr
            config : config
            list_desk_items         : new Lst # root items 
            selected_list_desk_items: new Lst # path list
        
        @list_desk_items.push new DeskItem "Files", "OrganisationFiles"
        @list_desk_items.push new DeskItem "Applications", "Applications"
        @list_desk_items.push new DeskItem "Admin", "Admin"
        @list_desk_items.push new DeskItem "Users", "Users"
        @list_desk_items.push new DeskItem "Logs", "Logs"
        
        @selected_list_desk_items.push @list_desk_items[0]
        
        @layout = new LayoutManagerData
              sep_norm: 0
              children: [ 
                      {
                          panel_id: "DeskListView"
                          immortal: true
                                  
                      }, {
                          panel_id: "DeskNavigatorView"
                          strength: 3,
                      } 
              ]
    
    
    
    
    