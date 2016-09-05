# Copyright 2015 SpinalCom  www.spinalcom.com

#
# This file is part of SpinalCore.
#
# SpinalCore is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SpinalCore is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with SpinalCore. If not, see <http://www.gnu.org/licenses/>.



#
class ModelEditorItem_NewTreeItem extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        # default values
        @class = "TreeItem_Parametric"
        @name = "Item"
        
        
        # attribute class
        @classTxt = new_dom_element
            parentNode : @ed
            nodeName   : "span"
            txt: "Class:"
            style      :
                display : "inline-block"
                fontSize : 12
                color: "#262626"
                width: 0.3*@ew + "%"           
                paddingLeft : 0.5 * (100 - @get_item_width()) + "%"                
                paddingTop : "5px"               
        @classInput = new_dom_element
            parentNode: @ed
            nodeName: "input"
            value: @class
            style:
                width: 0.7*@ew + "%"
            onchange  : =>
                @snapshot()
                @class = @classInput.value        
        
        
        
        # attribute name
        @nameTxt = new_dom_element
            parentNode : @ed
            nodeName   : "span"
            txt: "Name:"
            style      :
                display : "inline-block"
                fontSize : 12
                color: "#262626"
                width: 0.3*@ew + "%"           
                paddingLeft : 0.5 * (100 - @get_item_width()) + "%"                
                paddingTop : "5px"               
        @nameInput = new_dom_element
            parentNode: @ed
            nodeName: "input"
            value: @name
            style:
                width: 0.7*@ew + "%"
            onchange  : =>
                @snapshot()
                @name = @nameInput.value


#         # attribute type
#         @typeTxt = new_dom_element
#             parentNode : @ed
#             nodeName   : "span"
#             txt: "Type:"
#             style      :
#                 display : "inline-block"
#                 fontSize : 12
#                 color: "#262626"
#                 width: 0.3*@ew + "%"           
#                 paddingLeft : 0.5 * (100 - @get_item_width()) + "%"          
#                 paddingTop : "5px"
#         @typeSelect = new_dom_element
#             parentNode: @ed
#             nodeName  : "select"
#             onchange  : =>
#                 @snapshot()
#                 @type = @typeSelect.value
#             style:
#                 width: 0.7*@ew + "%"
#                 
#         for type in [ 'Val', 'Str', 'Bool', 'Lst', 'TypedArray_Int32' ]
#             new_dom_element
#                 parentNode : @typeSelect
#                 nodeName   : "option"
#                 txt        : type
#                 value      : type            
#         @type = @typeSelect.value
# 
# 
#         # attribute init value
#         @valTxt = new_dom_element
#             parentNode : @ed
#             nodeName   : "span"
#             txt: "Value:"
#             style      :
#                 display : "inline-block"
#                 fontSize : 12
#                 color: "#262626"
#                 width: 0.3*@ew + "%"           
#                 paddingLeft : 0.5 * (100 - @get_item_width()) + "%"          
#                 paddingTop : "5px"
#         @valInput = new_dom_element
#             parentNode: @ed
#             nodeName: "input"
#             style:
#                 width: 0.7*@ew + "%"
#             onchange  : =>
#                 @snapshot()
#                 @val = @valInput.value


        # confirmation
        @confirmContainer = new_dom_element
            parentNode : @ed
            nodeName   : "span"
            style      :
                display : "inline-block"
                textAlign: "center"
                paddingTop : "5px"      
                width: @ew + "%"
        @confirm = new_dom_element
            parentNode: @confirmContainer
            type: "text"
            nodeName: "button"
            txt: "Create TreeItem"
            onclick: =>
                if @name and @class
                    item = new window[@class]()
                    item._name.set @name
                    item._name_class.set @class
                    @model.add_child item
                
                
                
#             onchange  : =>
#                 @snapshot()
#                 @model.set @input.value
#             onfocus   : =>
#                 @get_focus()?.set @process_id
# 
#         @ev?.onmousedown = =>
#             @get_focus()?.set @process_id
                
#     onchange: ->
#         if @type.has_been_modified()
#             new ModelEditorItem_Input
#                 model: 
#         
#             console.log @model
#             console.log @name
#             console.log @type

        