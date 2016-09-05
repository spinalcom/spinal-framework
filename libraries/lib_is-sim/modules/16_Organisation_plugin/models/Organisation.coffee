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
class Organisation extends Model
    constructor: (name = "", config ) ->
        super( )
        @add_attr
            name  :  name
            admin_users         : new Lst
            list_users          : new Lst
            list_logs           : new Lst
            list_applications   : new Lst
            created_at          : new Date()
            modify_at           : new Date()
            directory           : new Directory
            
        @admin_users.push config.account if config?
        @list_users.push config.account if config?
            
        
        
            
            
            
            
            