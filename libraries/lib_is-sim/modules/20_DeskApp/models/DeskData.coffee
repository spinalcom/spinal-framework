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
class DeskData extends Model
    constructor: (config) ->
        super()
        
        @add_attr
            config : config
        
        @add_attr
            list_desk_items         : @config.list_desk_items # root items 
            selected_list_desk_items: @config.selected_list_desk_items # path list
            #list_desk_items         : new Lst # root items 
            #selected_list_desk_items: new Lst # path list
        
        @layout = new LayoutManagerData
            sep_norm: 0
            children: [ 
                    {
                        sep_norm: 1
                        children: [
                            {
                              panel_id: "DeskListView"
                              immortal: true
                            }, 
#                             {
#                               panel_id: "MessageListView"
#                               immortal: true
#                             }
                        ]
                                
                    }, {
                        panel_id: "DeskNavigatorView"
                        strength: 3,
                    } 
            ]