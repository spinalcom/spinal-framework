#
class ZigbeeClusterModel extends Model
    constructor: ( params = {} ) ->
        super()

        @commandSender = null

        @add_attr
            id: if params.id? then params.id else '0000' # cluster id
            name: if params.name? then params.name params.name else "Unknown Zigbee Cluster"

    @parseTime: (timeInt) ->
      timerBytes = timeInt.toString(16).replace(/((.){1,2})/g,'0x$1').split(/(0x..?)/).filter(Boolean).reverse()

      if (timerBytes.length == 1)
        timerBytes.push('0x0')
      else if (timerBytes.length > 2)
        timerBytes = timerBytes.slice(0, 2)

      return timerBytes
