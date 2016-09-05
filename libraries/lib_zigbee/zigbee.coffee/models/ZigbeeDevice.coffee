#
class ZigbeeDevice extends Model
    constructor: ( params = {} ) ->
        super()
        
        @add_attr
            id: if params.id? then params.id else '0000'
            name: if params.name? then params.name else "Unknown Zigbee Device"
            endpoint: if params.endpoint? then params.endpoint else '00'
            clusters: []
