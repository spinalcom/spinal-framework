#
class IASWarningDevice extends ZigbeeClusterModel
    constructor: ( params = {} ) ->
        super(params)

        @startProcess = null

        @add_attr
            status: new ConstrainedVal( 0, { min: 0, max: 1 } ) # on/off
            timer: 0 # timeout for the change of status

        @name.set 'IAS Warning Device'

    startFrame: ( options = {} ) ->

        # TODO: make a function to convert time to hex
        timerBytes = if options.timer? then options.timer.toString(16).replace(/((.){1,2})/g,'0x$1').split(/(0x..?)/).filter(Boolean).reverse() else [ '0x01', '0x00' ] 

        if (timerBytes.length == 1)
          timerBytes.push('0x0')
        else if (timerBytes.length > 2)
          timerBytes = timerBytes.slice(0, 2)

        headerBytes = [ '0x01', '0x01', '0x00' ];
        alarmTypeBytes = [ '0x11' ];

        frame =
          clusterId: '0502',
          profileId: '0104',
          data: headerBytes.concat(alarmTypeBytes, timerBytes)

        return frame
