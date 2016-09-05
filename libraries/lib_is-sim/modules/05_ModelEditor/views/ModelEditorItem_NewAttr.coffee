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
class ModelEditorItem_NewAttr extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        # default values
        @name = "my_attribute"   
#         @val = ""
        
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


        # attribute type
        @typeTxt = new_dom_element
            parentNode : @ed
            nodeName   : "span"
            txt: "Type:"
            style      :
                display : "inline-block"
                fontSize : 12
                color: "#262626"
                width: 0.3*@ew + "%"           
                paddingLeft : 0.5 * (100 - @get_item_width()) + "%"          
                paddingTop : "5px"
        @typeSelect = new_dom_element
            parentNode: @ed
            nodeName  : "select"
            onchange  : =>
                @snapshot()
                @type = @typeSelect.value
            style:
                width: 0.7*@ew + "%"
                
        for type in [ 'Val', 'Str', 'Bool', 'Lst', 'TypedArray_Int32', 'Mesh', 'Point' ]
            new_dom_element
                parentNode : @typeSelect
                nodeName   : "option"
                txt        : type
                value      : type            
        @type = @typeSelect.value


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
            txt: "Create attribute"
            onclick: =>
                if @name
#                     if @type == "Lst" then @val = @val.split ","
                
                    @model.mod_attr( @name, new window[@type] @val )
                    
#                     switch @type
#                         when "Val" then val = @val
#                         when "Str" then  val = "\""+ @val + "\""
#                         when "Bool" then ( if @val == "" or @val == "false" then val = false; else val = true )
#                         when "Lst" then  val = [ @val ]
#                     console.log val
                    
                    if not @model._gen_attr then @model.add_attr({ _gen_attr: [] })
                    @model._gen_attr.push [ @name, @type ]


        