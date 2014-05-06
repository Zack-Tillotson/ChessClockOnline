class @ClockView extends Backbone.View

  events:
    'click .active.clockbox': 'switchPlayer' # UI Events
    'click #controlsbox .btn': 'switchActive'

  initialize: ->
    @listenTo @model, 'sync', @updatePage
    @updatePage()

  updatePage: ->
    if @model.get('active')
      @beginBeatTimer()
    else
      @endBeatTimer()
    @render()

  switchActive: ->
    @model.set 'active',  not @model.get('active')
    @model.trigger 'edit'

  switchPlayer: ->
    @model.set 'current_player',  3 - @model.get('current_player')
    @model.trigger 'edit'

  render: ->

    $('#theclock').toggleClass 'active', @model.get('active')
    $('#p1box').toggleClass 'active', @model.get('current_player') is 1
    $('#p2box').toggleClass 'active', @model.get('current_player') is 2
    $('#p1box .time').html @prettifyTime @model.get('player_one_time')
    $('#p2box .time').html @prettifyTime @model.get('player_two_time')

  beginBeatTimer: =>
    @endBeatTimer()
    @timer = setInterval(@handleBeatTimer, 1000)

  endBeatTimer: =>
    clearInterval @timer if @timer
    @timer = null

  handleBeatTimer: =>
    @decrementTime $('.active.clockbox').find('.time')

  decrementTime: (el)->

    # Convert to seconds
    timeInSeconds = @parseTime el.html()

    # Decriment one
    timeInSeconds = timeInSeconds - 1

    el.html @prettifyTime(timeInSeconds)

    # Don't go past the end!
    @handleEndOfTime() if timeInSeconds is 0

  parseTime: (str) ->
    _.reduce str.split(':'), (memo, piece) ->
      memo * 60 + parseFloat(piece)
    , 0

  prettifyTime: (timeInSeconds) ->

    # Print nicely
    hours = "0#{parseInt(timeInSeconds / 3600)}".substr(-2)
    mins = "0#{parseInt((timeInSeconds % 3600) / 60)}".substr(-2)
    secs = "0#{parseInt(timeInSeconds % 60)}".substr(-2)

    "#{hours}:#{mins}:#{secs}"

  handleEndOfTime: ->
    @endBeatTimer()
    @model.set 'active', false
