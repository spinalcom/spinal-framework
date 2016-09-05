#
class TransformItem extends TreeItem
    constructor: ->
        super()
        
        # default values
        @_name.set "Transform"
        @_ico.set "img/transform_16.png"
        @_viewable.set true
        
        # attributes
        @add_attr
            transform: new Transform
    
    accept_child: ( ch ) ->
        ch instanceof MaskItem or 
        ch instanceof DiscretizationItem or
        ch instanceof SketchItem or 
        ch instanceof MeshItem or 
        ch instanceof ImgSetItem or
        ch instanceof ImgItem
                
        
    sub_canvas_items: ->
        flat = []
        for ch in @_children
            CanvasManager._get_flat_list flat, ch

        trans = [ 0, 0, 0 ]
        torig = [ 0, 0, 0 ]
        if @transform.cur_points.length >= 1
            torig = @transform.cur_points[ 0 ].pos.get()
            trans = Vec_3.sub @transform.cur_points[ 0 ].pos, @transform.old_points[ 0 ].pos
        
        scale = 1
        angle = 0
        if @transform.cur_points.length == 2
            vec_old = Vec_3.sub @transform.old_points[ 1 ].pos.get(), @transform.old_points[ 0 ].pos.get()
            vec_cur = Vec_3.sub @transform.cur_points[ 1 ].pos.get(), @transform.cur_points[ 0 ].pos.get()
            
            d_old = Vec_3.len vec_old
            d_cur = Vec_3.len vec_cur
            
            if d_old
                scale = d_cur / d_old
                
                vec_old = Vec_3.dis vec_old, d_old
                vec_cur = Vec_3.dis vec_cur, d_cur
                
                Z = Vec_3.cro vec_old, vec_cur
                y = Vec_3.len Z
                if y
                    Z = Vec_3.dis Z, y
                    x = Vec_3.dot vec_old, vec_cur
                    angle = Math.atan2 y, x
            # console.log "Scale * " + scale + " - Rotation " + angle * 180 / 3.14159 + " deg"
    
        lst = for ch in flat
            do ( ch ) => 
                draw: ( info ) ->
                    n_info = {}
                    for key, val of info
                        n_info[ key ] = val
                    
                    n_info.re_2_sc =
                        proj: ( p ) ->
                            np = Vec_3.add p, trans
                            np = Vec_3.sub np, torig
                            if angle
                                np = Vec_3.rot np, Vec_3.mus angle, Z
                            if scale
                                np = Vec_3.mus scale, np
                            np = Vec_3.add np, torig
                            
                            info.re_2_sc.proj np
                        
                    ch.draw n_info
                    
                z_index: -> 
                    ch.z_index()
        
        lst.push @transform
        
        return lst
    
    get_movable_entities: ( res, info, pos, phase ) ->
        @transform.get_movable_entities res, info, pos, phase
