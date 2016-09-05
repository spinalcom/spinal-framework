
class ReportProcess extends Process

    constructor: (@destination, @model, @zapi) ->
      super(@model)

      @reportId = 0

    onchange: () ->

      if @model.reportPeriod.has_been_modified()

        if isNaN @model.reportPeriod.get()
          @model.reportPeriod.set 0

        # clear older intervalId
        clearInterval @reportId

        # set new interval
        reportPeriod = @model.reportPeriod.get()

        if reportPeriod > 0

          @reportId = setInterval () =>

              @report()

            , reportPeriod*1000

    #TODO: move this to model?
    report: () ->
      @zapi.sendCommand(@destination, @model.reportFrame()).then (response) =>

        # save in fifo
        @model.value.unshift response.value
        if @model.value.length >= 10
          @model.value.pop()
