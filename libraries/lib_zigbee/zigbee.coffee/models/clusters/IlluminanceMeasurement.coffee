#
class IlluminanceMeasurement extends ZigbeeClusterModel
    constructor: ( params = {} ) ->
        super(params)

        @reportProcess = null

        @add_attr
            value: [] # historical value of measurement
            reportPeriod: 0

        @name.set 'Illuminance Measurement'

    reportFrame: () ->

        frame =
          clusterId: '0400',
          profileId: '0104',
          data: [ '0x00', '0x01', '0x00', '0x00', '0x00' ]

        return frame
