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




# Tree application
class DeskApp extends View
    constructor: ( @bel, @data = new TreeAppData ) ->
        @user_email = Cookies.set("email")
        
        @layout = @data.layout

        @el = new_dom_element
            parentNode: @bel
            id : "organisation_container"
            style:
                position: "absolute"
                left    : 0
                right   : 0
                top     : "32px"
                bottom  : 0  
                
        @lm = new LayoutManager @el, @layout
        @lm.new_panel_instance = ( data ) => @_new_panel_instance data
        @lm.show()
        
                    
    _new_panel_instance : ( data ) ->  
        if data.panel_id == "DeskListView"
            res = new LayoutManagerPanelInstance @el, data, "Desk"
            res.div.className = "PanelInstanceTreeView"
            new DeskListView res.div, this
            return res
        
        if data.panel_id == "DeskNavigatorView"
            res = new LayoutManagerPanelInstance @el, data
            res.div.className = "PanelInstanceContextBar"
            new DeskNavigatorView res.div, this
            return res
            
        if data.panel_id == "MessageListView"
            res = new LayoutManagerPanelInstance @el, data
            res.div.className = "PanelInstanceContextBar"
            new MessageListView res.div, this
            return res
        
        res = new LayoutManagerPanelInstance @el, data
        res.div.className = "PanelInstanceContextBar"
        return res 
    
   
        