class @ClockView extends Backbone.View

  events:
    'click .clockbox': 'switchPlayer' # UI Events
    'click #controlsbox .btn': 'switchActive'

  initialize: ->
    @listenTo @model, 'sync', @updatePage
    @updatePage()
    @channel = pusher.subscribe "private-chess-clock-#{@model.get('key')}"
    @channel.bind 'pusher:subscription_succeeded', @pusherSubscribedHandler
    @channel.bind "client-#{@model.get('key')}-sync", @pusherSyncHandler

  updatePage: ->
    if @model.get('active')
      @beginBeatTimer()
    else
      @endBeatTimer()
    @render()

  switchActive: ->
    @model.set 'active',  not @model.get('active')
    @model.trigger 'edit'
    @triggerSync()

  switchPlayer: ->
    @model.set 'current_player',  3 - @model.get('current_player')
    @model.trigger 'edit'
    @triggerSync()

  render: ->

    $('#theclock').toggleClass 'active', @model.get('active')
    $('#p1box').toggleClass 'active', @model.get('current_player') is 1
    $('#p2box').toggleClass 'active', @model.get('current_player') is 2
    $('#p1box .time').html @prettifyTime @model.get('player_one_time')
    $('#p2box .time').html @prettifyTime @model.get('player_two_time')

  triggerSync: =>
    console.log "Triggering sync!", "client-#{@model.get('key')}-sync", {yep: 'hai'}
    @channel.trigger "client-#{@model.get('key')}-sync", @getCurrentModel()

  pusherSubscribedHandler: (data) =>
    console.log "pusher subscribed!", data

  pusherSyncHandler: (data) =>
    console.log "pusher client sync!", data
    @model.set data
    @model.trigger 'edit'

  getCurrentModel: =>
    key: @model.get 'key'
    active: @model.get 'active'
    current_player: @model.get 'current_player'
    player_one_time: @parseTime $('#p1box .time').html()
    player_two_time: @parseTime $('#p2box .time').html()

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
