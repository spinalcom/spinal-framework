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

class GraphView extends View
    constructor: ( @el, @model, @params) ->
        super @model

    onchange: ->
        if @model.has_been_modified   
            data = []    
            @tojson data, @model 
            root = data[0]
            @update_tree root 


    tojson: (d, m) ->
        if m._children.length !=0
            d.push
                "name": m._name.get()
                "children": []
            for child in m._children
                @tojson d[d.length-1]["children"], child
        else
            d.push 
                "name": m._name.get()    


    update_tree: (root) ->

        # Used to access object properties outside the scope
        _this = this;

        # Defines default style for buttons
        @style =
            button:
                height: 15
                marginRight: 10

        margin = 
            top: 20
            right: 20
            bottom: 20
            left: 20

        width = @params.width - (margin.right) - (margin.left)
        height = @params.height - (margin.top) - (margin.bottom)

        # Flush element content
        @el.innerHTML = ""

        # Create toolbar
        popup_toolbar = new_dom_element
            className : "popup_toolbar"
            parentNode: @el
            style:
                color: "#000"

        # Create zoom in button
        ico_zoom_in = new_dom_element
            parentNode : popup_toolbar
            nodeName   : "img"
            alt        : "Zoom In"
            title      : "Zoom In"
            src        : "img/zoom_in.png"
            className  : "graph_icons"
            style      :
                height     : _this.style.button.height
                marginRight: _this.style.button.marginRight
            onmousedown: (evt) =>
                zoomGraph(0.05)

        # Create zoom in button
        ico_zoom_in = new_dom_element
            parentNode : popup_toolbar
            nodeName   : "img"
            alt        : "Zoom Out"
            title      : "Zoom Out"
            src        : "img/zoom_out.png"
            className  : "graph_icons"
            style      :
                height     : _this.style.button.height
                marginRight: _this.style.button.marginRight
            onmousedown: (evt) =>
                zoomGraph(-0.05)

        # Create rotation button
        ico_rotate = new_dom_element
            parentNode : popup_toolbar
            nodeName   : "img"
            alt        : "Rotate"
            title      : "Rotate"
            src        : "img/rotate.png"
            className  : "graph_icons"
            style      :
                height     : _this.style.button.height
                marginRight: _this.style.button.marginRight
            onmousedown: (evt) =>
                rotateGraph()

        # Create graph
        @scale = 0.8;
        @orientation = -1 # 1: horizontal, -1: vertical
        @canvas = d3.select('svg').remove()
        @canvas = d3.select(@el).append('svg').attr('width', width + margin.right + margin.left).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

        # Changes graph scale according to *val*
        zoomGraph = (val) ->
            _this.scale += val
            _this.canvas.attr('transform', 'translate(' + margin.left + ',' + margin.top + ') scale(' + _this.scale + ')')

        # Rotates graph constantly, either horizontal or vertical
        rotateGraph = () ->
            _this.orientation *= (-1)

            # Rotates the edges
            _this.canvas.selectAll('.link').attr 'd', d3.svg.diagonal().projection((d) ->
                if _this.orientation > 0
                    [d.x, d.y]
                else
                    [d.y, d.x]
                )
            # Rotates the nodes
            _this.node.attr('transform', (d) ->
                if _this.orientation > 0
                    'translate(' + d.x + ',' + d.y + ')'
                else
                    'translate(' + d.y + ',' + d.x + ')'
                )

        @tree = d3.layout.tree().size([
            height
            width
        ])

        @nodes = @tree.nodes(root)
        links = @tree.links(@nodes)

        @node = @canvas.selectAll('node').data(@nodes).enter().append('g').attr('class', 'node').attr('transform', (d) ->
            'translate(' + d.y + ',' + d.x + ')'
            )
        
        @node.append('circle').attr('r', 5).attr 'fill', 'steelblue'
        @node.append('text').attr('dy', '20px').text (d) ->
            d.name
            
        diagonal = d3.svg.diagonal().projection((d) ->
            [
                d.y
                d.x
            ]
            )
            
        @canvas.selectAll('.link').data(links).enter().append('path').attr('class', 'link').attr('fill', 'none').attr('stroke', '#ADADAD').attr 'd', diagonal
