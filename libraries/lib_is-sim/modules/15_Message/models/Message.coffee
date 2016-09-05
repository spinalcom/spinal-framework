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
class Message extends Model
    constructor: (  input_text = "" ) ->
        super()
        
        @add_attr
            date : ""
            user : Cookies.set("email")
            text:  ""
        
        @date.set (new Date()).toString().split(' ').splice(1,3).join(' ')
        @text.set input_text
