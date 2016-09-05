#
class FloorItem extends FlatItem
    constructor: ( name = "Floor", @num, params={} ) ->
        super()

        @_name.set name
        @_viewable.set false

        @make_numa()



    make_numa: ( ) -> 
        @_children.clear()
    
        
        if @num <= 5
            Space_1 = new FlatItem ("Space 1")
            Space_2 = new FlatItem ("Space 2")
            Stairs_1 = new FlatItem ("Stairs 1")
            @add_child Space_1 
            @add_child Space_2 
            @add_child Stairs_1 
        
            Space_1._width.set 3
            Space_1._length.set 3
            Space_1._height.set 3
            Space_1._center.pos[0].set 10.5       
            Space_1._center.pos[1].set (3*@num + 1.5)
            Space_1._center.pos[2].set -3.5
            
            Space_2._width.set 7
            Space_2._length.set 7
            Space_2._height.set 3
            Space_2._center.pos[0].set 8.5       
            Space_2._center.pos[1].set (3*@num + 1.5)
            Space_2._center.pos[2].set 1.5        
        
            Stairs_1._width.set 4
            Stairs_1._length.set 3
            Stairs_1._height.set 3.2
            Stairs_1._center.pos[0].set 7       
            Stairs_1._center.pos[1].set (3*@num + 1.5)
            Stairs_1._center.pos[2].set -3.5    
            Stairs_1._is_ok.set 1
        
        if @num <= 4
            Space_3 = new FlatItem ("Space 3")
            @add_child Space_3 
        
            Space_3._width.set 10
            Space_3._length.set 10
            Space_3._height.set 3
            Space_3._center.pos[0].set 0
            Space_3._center.pos[1].set (3*@num + 1.5)
            Space_3._center.pos[2].set 0  
        
        if @num <= 6
            Space_4 = new FlatItem ("Space 4")
            Stairs_2 = new FlatItem ("Stairs 2")
            @add_child Space_4 
            @add_child Stairs_2 
        
            Space_4._width.set 5
            Space_4._length.set 7
            Space_4._height.set 3
            Space_4._center.pos[0].set -7.5       
            Space_4._center.pos[1].set (3*@num + 1.5)
            Space_4._center.pos[2].set -1.5      
            
            Stairs_2._width.set 5
            Stairs_2._length.set 3
            Stairs_2._height.set 3.2
            Stairs_2._center.pos[0].set -7.5       
            Stairs_2._center.pos[1].set (3*@num + 1.5)
            Stairs_2._center.pos[2].set 3.5        
            Stairs_2._is_ok.set 1
        
        if @num == 0
            Space_1.color.r.set 35
            Space_1.color.g.set 31
            Space_1.color.b.set 32
            Space_2.color.r.set 35
            Space_2.color.g.set 31
            Space_2.color.b.set 32
            Space_3.color.r.set 35
            Space_3.color.g.set 31
            Space_3.color.b.set 32
            Space_4.color.r.set 35
            Space_4.color.g.set 31
            Space_4.color.b.set 32            
            
        else if @num == 1
            Space_1.color.r.set 255
            Space_1.color.g.set 240
            Space_1.color.b.set 0
            Space_2.color.r.set 255
            Space_2.color.g.set 240
            Space_2.color.b.set 0
            Space_3.color.r.set 255
            Space_3.color.g.set 240
            Space_3.color.b.set 0
            Space_4.color.r.set 255
            Space_4.color.g.set 240
            Space_4.color.b.set 0
            
        else if @num == 2
            Space_1.color.r.set 1
            Space_1.color.g.set 174
            Space_1.color.b.set 242
            Space_2.color.r.set 1
            Space_2.color.g.set 174
            Space_2.color.b.set 242
            Space_3.color.r.set 1
            Space_3.color.g.set 174
            Space_3.color.b.set 242
            Space_4.color.r.set 1
            Space_4.color.g.set 174
            Space_4.color.b.set 242
            
        else if @num == 3
            Space_1.color.r.set 239
            Space_1.color.g.set 31
            Space_1.color.b.set 143
            Space_2.color.r.set 239
            Space_2.color.g.set 31
            Space_2.color.b.set 143
            Space_3.color.r.set 239
            Space_3.color.g.set 31
            Space_3.color.b.set 143
            Space_4.color.r.set 239
            Space_4.color.g.set 31
            Space_4.color.b.set 143
            
        else if @num == 4
            Space_1.color.r.set 247
            Space_1.color.g.set 247
            Space_1.color.b.set 247        
            Space_2.color.r.set 247
            Space_2.color.g.set 247
            Space_2.color.b.set 247   
            Space_3.color.r.set 247
            Space_3.color.g.set 247
            Space_3.color.b.set 247   
            Space_4.color.r.set 247
            Space_4.color.g.set 247
            Space_4.color.b.set 247               
            
        else if @num == 5
            Space_1.color.r.set 188
            Space_1.color.g.set 189
            Space_1.color.b.set 193  
            Space_2.color.r.set 188
            Space_2.color.g.set 189
            Space_2.color.b.set 193   
            Space_4.color.r.set 188
            Space_4.color.g.set 189
            Space_4.color.b.set 193   
            
        if @num == 6
            Space_4.color.r.set 35
            Space_4.color.g.set 31
            Space_4.color.b.set 32               
            
  
