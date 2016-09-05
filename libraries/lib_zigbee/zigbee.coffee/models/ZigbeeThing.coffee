class ZigbeeThing extends TreeItem
    constructor: ( params = {} ) ->
        super()
        
        if params.name? then @_name.set params.name else @_name.set "Unknown Thing"

        @add_attr
            name: @_name
            id:
              ieeeAddress: "0"
              networkAddress: "0"
            type: 3 # uknown by default
            devices: []
            siblings: [] # other routers
            reachable: true

        # TODO: this should be in another file
        #clusterMapping = {}
        #clusterMapping['0400'] = IlluminanceMeasurement
        #clusterMapping['0502'] = IASWarningDevice
        #deviceMapping = {}
        #deviceMapping['0106'] = 'Light Sensor'
        #deviceMapping['0403'] = 'IAS Warning Device'

        # TODO: check for missing parameters
        if params.zigbeeInfo? and params.communication?

          @id.ieeeAddress.set params.zigbeeInfo.ieeeAddress
          @id.networkAddress.set params.zigbeeInfo.networkAddress

          destinationInfo =
            ieeeAddress: params.zigbeeInfo.ieeeAddress
            networkAddress: params.zigbeeInfo.networkAddress

          for endpoint in params.zigbeeInfo.endpoints
            # create device
            zigbeeDevice = new ZigbeeDevice
              id: endpoint.deviceId,
              name: deviceMapping[endpoint.deviceId]
              endpoint: endpoint.value

            if @name.get() == 'Unknown Thing'
              @name.set(deviceMapping[endpoint.deviceId])
            
            destinationInfo.endpoint = endpoint.value

            # add clusters
            for cluster in endpoint.clusterList

              if clusterMapping.hasOwnProperty cluster
                clusterInstance = new clusterMapping[cluster]({ id: cluster })
                child = {}
                child[clusterInstance.name.get().replace(/ /g, '')] = clusterInstance

                # TODO: maybe a function start_reporting in each cluster
                # TODO: unify start and reportprocess?
                # start reporting
                if typeof clusterInstance.reportProcess != 'undefined'
                  clusterInstance.reportProcess = new ReportProcess(destinationInfo, clusterInstance, params.communication)

                # listen for start actions
                if typeof clusterInstance.startProcess != 'undefined'
                  clusterInstance.startProcess = new StartProcess(destinationInfo, clusterInstance, params.communication)

                zigbeeDevice.clusters.push(child)

            # add device
            child = {}
            child[deviceMapping[endpoint.deviceId].replace(/ /g, '')] = zigbeeDevice
            @devices.push(child)

    addThing: (thing, zapi) ->

      zigbeeThing = @getThing thing.ieeeAddress

      if zigbeeThing == null
        # create thing
        zigbeeThing = new ZigbeeThing
          zigbeeInfo: thing
          communication: zapi

        # add thing to virtual network
        @add_child zigbeeThing
      else
        # listen and send events if it's not doing it already
        zigbeeThing.startInteraction
          communication: zapi

    accept_child: ( ch ) ->
        ch instanceof ZigbeeThing

    getThing: (ieeeAddress) ->

      i = @_children.length

      while i--
        if @_children[i].id.ieeeAddress.get() == ieeeAddress
          return @_children[i]

      return null

    startInteraction: ( params = {} ) ->
        # TODO: check for missing parameters
        if params.communication?

          destinationInfo =
            ieeeAddress: @id.ieeeAddress.get()
            networkAddress: @id.networkAddress.get()

          for deviceItem in @devices
            device = deviceItem[deviceItem._attribute_names[0]]

            destinationInfo.endpoint = device.endpoint.get()

            for clusterItem in device.clusters
              cluster = clusterItem[clusterItem._attribute_names[0]]

              # TODO:  maybe a function start_reporting in each cluster
              # TODO: unify start and reportprocess?
              # start reporting
              if typeof cluster.reportProcess != 'undefined'
                cluster.reportProcess = new ReportProcess(destinationInfo, cluster, params.communication)

              # listen for start actions
              if typeof cluster.startProcess != 'undefined'
                cluster.startProcess = new StartProcess(destinationInfo, cluster, params.communication)

              @reachable.set(true)

