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



# -> creates a _can_be_computed attribute which can be used e.g. by the server to know if there's something to update
class TreeItem_Automatic extends TreeItem
    constructor: ->
        super()
        
        # attributes
        @add_attr
            _req_date: 1 # request date (updated by the @bind hereafter)
            _rep_date: 0 # response date (updated by the server after each computation)
            _messages            : []
                      
        
        # incrementation of _computation_req_date each time there's a "real" change
        @bind =>     
            if @has_been_directly_modified()
                if @_req_date.has_been_modified() # in this round
                    return
                if @_rep_date.has_been_modified() # in this round
                    return 
                @_req_date.add 1

    cosmetic_attribute: ( name ) ->
        name in [ "_rep_date", "_messages" ]

    nothing_to_do: ->
        @_req_date.get() == @_rep_date.get()
            
            