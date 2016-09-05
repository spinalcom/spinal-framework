#
class ZigbeeNetwork extends TreeItem
    constructor: ( name = "Network") ->
        super()

        @_name.set name

        # addThing executes in the context of the event emitter, so we need to save a reference for this instance
        self = this

        relationshipMapping = {}

        @add_attr
            discovery_active: false

        @addThing = (thing, zapi) ->

          # It is an end device
          if thing.parent? && thing.type == 2

            # Check if it has already been created
            if relationshipMapping[thing.parent]?

              relationshipMapping[thing.parent].reference.addThing thing, zapi

            else

              zigbeeThing = new ZigbeeThing
                zigbeeInfo: thing
                communication: zapi

              # Add in table for later addition
              relationshipMapping[thing.ieeeAddress] =
                parent: thing.parent
                reference: zigbeeThing

          # Should be either routers or end devices connected to coordinator
          else

            zigbeeThing = self.getThing thing.ieeeAddress

            if zigbeeThing == null
              # create thing
              zigbeeThing = new ZigbeeThing
                zigbeeInfo: thing
                communication: zapi

              # add thing to virtual network
              self.add_child zigbeeThing
            else
              # listen and send events if it's not doing it already
              zigbeeThing.startInteraction
                communication: zapi

            # Add router to mapping
            relationshipMapping[thing.ieeeAddress] =
              siblings: thing.siblings
              reference: zigbeeThing

        @discoveryEnded = () ->

          @removeAllListeners('thing_discovered');
          @removeAllListeners('discovery_ended');
          @removeAllListeners('discovery_started');

          # TODO: add devices to the tree
          #for own ieeeAddress,thing of relationshipMapping
          #  if thing.parent? and relationshipMapping[thing.parent]?
           #   relationshipMapping[thing.parent].reference.addThing thing.reference
              #else
              #  console.log 'WARNING: thing\'s parend doesn\'t exists'

          self.discovery_active.set(false);

        @discoveryStarted = () ->

          # TODO: if it's a tree
          for thing in self._children
            thing.reachable.set(false)
            for endDevice in thing._children
              endDevice.reachable.set(false)

    accept_child: ( ch ) ->
        ch instanceof ZigbeeThing

    getThing: (ieeeAddress) ->

      i = @_children.length

      while i--
        if @_children[i].id.ieeeAddress.get() == ieeeAddress
          return @_children[i]

      return null

    display_suppl_context_actions: ( context_action )  ->
        context_action.push new TreeAppModule_ZigBeeNetwork

