# Copyright 2015 SpinalCom  www.spinalcom.com
#  
#
# This file is part of SpinalCore.
#
# Soda is free software: you can redistribute it and/or modify
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
class TreeAppModule_Logo_SC extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Structure Computation'
        @visible = true
                
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.process_id and 
            app.data.focus.get() != app.treeview.process_id
      
        @icon_app = new Lst
        
        @actions.push
            ico: "img/Logo_StructureComputation_gris.png"
            siz: 1.8
            txt: "Structure Computation"
            ina: _ina
            fun: ( evt, app ) =>
                #alert "no action"