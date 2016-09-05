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
class ModelEditorItem_MoveButtons extends ModelEditorItem
    constructor: ( params ) ->
        super params
       
            
        @downdown = new_dom_element
            parentNode: @ed
            nodeName: "button"
            txt: "<<"
            style     :
                width: 0.2 * @ew + "%"
            onmousedown: =>
                @model._down.set true
            onmouseup: =>
                @model._down.set false
              
        @down = new_dom_element
            parentNode: @ed
            nodeName: "button"
            txt: "<"
            style     :
                width: 0.2 * @ew + "%"
            onclick: =>
                @model._down._signal_change()
                @model.val.set @model.val.get() - @model.step.get()
             

        @input = new_dom_element
            parentNode: @ed
            type      : "text"
            nodeName  : "input"
            style     :
                width: 0.2 * @ew + "%"
                textAlign: "center"
            onchange  : =>
                @snapshot()
                @model.step.set @input.value
            onfocus   : =>
                @get_focus()?.set @process_id   

        @up = new_dom_element
            parentNode: @ed
            nodeName: "button"
            txt: ">"
            style     :
                width: 0.2 * @ew + "%"
            onclick: =>
                @model._up._signal_change()
                @model.val.set @model.val.get() + @model.step.get()
    
        @upup = new_dom_element
            parentNode: @ed
            nodeName: "button"
            txt: ">>"
            style     :
                width: 0.2 * @ew + "%"
            onmousedown: =>
                @model._up.set true
            onmouseup: =>
                @model._up.set false    


    onchange: ->
        if @model._down.get() == true
            @model._down._signal_change()
            @model.val.set @model.val.get() - @model.step.get()

        if @model._up.get() == true
            @model._up._signal_change()
            @model.val.set @model.val.get() + @model.step.get()
            
        if @model.has_been_modified()
            @input.value = @model.step.get()
            
        if @get_focus()?.has_been_modified()
            if @get_focus().get() == @process_id
                setTimeout ( => @input.focus() ), 1
            else
                @input.blur()