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
class DeskListView extends View
    constructor: ( @el, @tree_app, params = {} ) ->        
        @app_data = @tree_app.data
        super @app_data
        
        @icon_container = new_dom_element
            nodeName  : "div"
            parentNode: @el
        
        
    onchange: ->
        
        if @app_data.selected_list_desk_items.has_been_directly_modified
            @el.appendChild @icon_container
            while @icon_container.firstChild?
                @icon_container.removeChild @icon_container.firstChild
            

            block = new_dom_element
                parentNode : @icon_container
                nodeName   : "span"
            
            
            for item, j in @app_data.list_desk_items 
                selected = false
                if @app_data.selected_list_desk_items.contains item
                  selected = true
                @draw_item item, block, 1, selected

    draw_item: ( item, parent, size, selected ) ->               
        do ( item ) =>
            container_div = new_dom_element
                parentNode : parent
                nodeName   : "div"
                #txt        : item._name
                #alt        : item._name
                #title      : item._name
                onmousedown: ( evt ) =>
                    #alert "selection d'un item"
                    @app_data.selected_list_desk_items.clear()
                    @app_data.selected_list_desk_items.push item 
                
                style      :
                    height     : 30
                    width      : "100%"
                    #border     : "1px solid blue"
                    fontWeight : "bold"
                    cursor     : "pointer"
                    background : "#b8dbe9" if selected
                    
            container_txt = new_dom_element
                parentNode : container_div
                nodeName   : "div"
                txt        : item._name
                #alt        : item._name
                #title      : item._name
                
                style      :
                    height     : 25
                    #border     : "1px solid grey"
                    fontWeight : "bold"
                    fontSize   : "18px"
                    padding     : "5px 0 0 50px"
                    cursor     : "pointer"

                        
                
                    
                  
            