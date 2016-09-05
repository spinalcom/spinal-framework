
class StartProcess extends Process

    constructor: (@destination, @model, @zapi) ->
      super(@model)

    onchange: () ->

      if @model.status.has_been_modified()

        if @model.status.get() == 1

          @start()


    #TODO: move this to model?
    start: () ->

      frameOptions =
        timer: @model.timer.get() # in seconds

      generalOptions =
        ignoreResponse: true

      @zapi.sendCommand(@destination, @model.startFrame(frameOptions), generalOptions).then (response) =>

        console.log('Alarm fired')

        setTimeout () =>
          @model.status.set(0)
        , @model.timer.get() * 1000
