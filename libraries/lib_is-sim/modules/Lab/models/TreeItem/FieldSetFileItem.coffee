# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
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
class FieldSetFileItem extends TreeItem
    constructor: ( file ) ->
        super()
        
                
        if file?
            @_name.set file.name  
            @add_attr
                _file: file
                _ptr: file._ptr
                
        field_set = new FieldSet
        @add_attr
            _fs_ptr: new Ptr field_set
           
            
          
            
    
            