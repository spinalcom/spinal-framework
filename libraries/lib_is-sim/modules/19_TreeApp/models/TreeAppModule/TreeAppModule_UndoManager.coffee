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
class TreeAppModule_UndoManager extends TreeAppModule
    constructor: ->
        super()
        
        @name = ''
        
        @actions.push
            ico: "img/undo1.png"
            siz: 0.9
            txt: "Undo"
            fun: ( evt, app ) -> app.undo_manager.undo()
            key: [ "Ctrl+Z" ]
            
        @actions.push
            ico: "img/redo1.png"
            siz: 0.9
            txt: "Redo"
            fun: ( evt, app ) -> app.undo_manager.redo()
            key: [ "Ctrl+Shift+Z" ]
        