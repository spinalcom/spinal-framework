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
class ModelEditorItem_NewClass extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        # default values
        @name = "MyItem"   
        
        # class name
        @nameTxt = new_dom_element
            parentNode : @ed
            nodeName   : "span"
            txt: "Class name:"
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


        # language option
        @languageTxt = new_dom_element
            parentNode : @ed
            nodeName   : "span"
            txt: "Language:"
            style      :
                display : "inline-block"
                fontSize : 12
                color: "#262626"
                width: 0.3*@ew + "%"           
                paddingLeft : 0.5 * (100 - @get_item_width()) + "%"          
                paddingTop : "5px"
        @languageSelect = new_dom_element
            parentNode: @ed
            nodeName  : "select"
            onchange  : =>
                @snapshot()
                @language = @languageSelect.value
            style:
                width: 0.7*@ew + "%"
                
        for type in [ 'JavaScript', 'CoffeeScript' ]
            new_dom_element
                parentNode : @languageSelect
                nodeName   : "option"
                txt        : type
                value      : type            
        @language = @languageSelect.value



#         # extend name
#         @extendTxt = new_dom_element
#             parentNode : @ed
#             nodeName   : "span"
#             txt: "Class extend:"
#             style      :
#                 display : "inline-block"
#                 fontSize : 12
#                 color: "#262626"
#                 width: 0.4*@ew + "%"           
#                 paddingLeft : 0.5 * (100 - @get_item_width()) + "%"                
#                 paddingTop : "5px"               
#         @extendInput = new_dom_element
#             parentNode: @ed
#             nodeName: "input"
#             value: @extend
#             style:
#                 width: 0.6*@ew + "%"
#             onchange  : =>
#                 @snapshot()
#                 @extend = @extendInput.value


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
            txt: "Create JS Class"
            onclick: =>
                if @name 
                    @model._class_export_name.set @name
                    @model._class_export_language.set @language
                    @model._class_export_state.set true
                
                
#                     if @language == "JavaScript"
#                         blob = new Blob([ @fileTextJS @name ], {type: "text/plain;charset=utf-8"})
#                         saveAs(blob, @name + ".js")
#                     else if @language == "CoffeeScript"
#                         blob = new Blob([ @fileTextCoffee @name ], {type: "text/plain;charset=utf-8"})
#                         saveAs(blob, @name + ".coffee")
# 
# 
#     fileTextJS: ( name ) ->
#         text = "function " + name + "() {\n
#     " + name + ".super(this);\n
# \n"
#         if @model._gen_attr
#             text += "
#     this.add_attr({\n"
#             for attr in @model._gen_attr
#                 text += "
#         "+ attr[0] + ": new " + attr[1] + ",\n"
#             text += "
#     });\n"
#         text += "
# }\n
# \n
# spinalCore.extend(" + name + ", " + @model._name_class.get() + ");"
#         
#         
#         
#     fileTextCoffee: ( name ) ->
#         text = "class " + name + " extends " + @model._name_class.get() + "\n
#     constructor: ( ) ->\n
#         super()\n
# \n"
#         if @model._gen_attr
#             text += "
#         @add_attr\n"
#             for attr in @model._gen_attr
#                 text += "
#             " + attr[0] + ": new " + attr[1] + "\n"
#         text += "\n"
  