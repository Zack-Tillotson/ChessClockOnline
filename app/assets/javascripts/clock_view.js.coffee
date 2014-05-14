class @ClockView extends Backbone.View

  events:
    'click .clockbox': 'switchPlayer' # UI Events
    'click #controlsbox #startbtn': 'switchActive'
    'click #controlsbox #pausebtn': 'switchActive'
    'click #controlsbox #resetbtn': 'resetState'
    'click #optionsbox .btn': 'changeTime'

  initialize: ->
    @listenTo @model, 'sync', @updatePage
    @updatePage()
    @channel = pusher.subscribe "private-chess-clock-#{@model.get('key')}"
    @channel.bind 'pusher:subscription_succeeded', @pusherSubscribedHandler
    @channel.bind "client-#{@model.get('key')}-sync", @pusherSyncHandler

  updatePage: ->
    if @model.status() is "active"
      @beginBeatTimer()
    else
      @endBeatTimer()
    $('#p1box .time').data("time", @model.get('player_one_time'))
    $('#p2box .time').data("time", @model.get('player_two_time'))

    @render()

  switchActive: ->
    @model.set 'active',  not @model.get('active')
    @model.trigger 'edit'
    @triggerSync()

  switchPlayer: ->
    if not $('#theclock').hasClass 'gameover'
      @model.set 'current_player',  3 - @model.get('current_player')
      @model.trigger 'edit'
      @triggerSync()

  changeTime: (e) ->
    if not $('#theclock').hasClass 'active'
      playerLocation = $(e.target).data 'player-loc'
      player = $(e.target).data 'player'
      value = parseInt $(e.target).data('value')
      prevValue = $("#{playerLocation} .time").data "time"

      @model.set "new_#{player}", Math.max(value + prevValue, 0)

      @model.trigger 'edit'
      @triggerSync()

  render: ->

    $('#theclock').toggleClass 'active', @model.status() is "active"
    $('#theclock').toggleClass 'gameover', @model.status() is "game_over"
    $('#theclock').toggleClass 'paused', @model.status() is "paused"
    $('#p1box').toggleClass 'active', @model.get('current_player') is 1
    $('#p2box').toggleClass 'active', @model.get('current_player') is 2
    $('#p1box .time').html @prettifyTime $('#p1box .time').data("time")
    $('#p2box .time').html @prettifyTime $('#p2box .time').data("time")

  triggerSync: =>
    console.log "Triggering sync!", "client-#{@model.get('key')}-sync", {yep: 'hai'}
    @channel.trigger "client-#{@model.get('key')}-sync", @getCurrentModel()

  pusherSubscribedHandler: (data) =>
    console.log "pusher subscribed!", data

  pusherSyncHandler: (data) =>
    @model.set data
    @model.trigger 'edit'

  getCurrentModel: =>
    key: @model.get 'key'
    active: @model.get 'active'
    current_player: @model.get 'current_player'
    player_one_time: $('#p1box .time').data("time")
    player_two_time: $('#p2box .time').data("time")

  beginBeatTimer: =>
    @endBeatTimer()
    @timer = setInterval(@handleBeatTimer, 1000)

  endBeatTimer: =>
    clearInterval @timer if @timer
    @timer = null

  handleBeatTimer: =>

    @decrementTime $('.active.clockbox').find('.time')

    # Don't go past the end!
    @handleEndOfTime() if $('.active.clockbox').find('.time').data('time') <= 0

    @render()

  decrementTime: (el)->

    # Convert to seconds
    timeInSeconds = el.data("time")

    # Decrement one
    timeInSeconds = timeInSeconds - 1

    # Update the UI
    timeInSeconds = el.data("time", timeInSeconds)

  prettifyTime: (timeInSeconds) ->

    # Print nicely
    hours = "0#{parseInt(timeInSeconds / 3600)}".substr(-2)
    mins = "0#{parseInt((timeInSeconds % 3600) / 60)}".substr(-2)
    secs = "0#{parseInt(timeInSeconds % 60)}".substr(-2)

    "#{hours}:#{mins}:#{secs}"

  handleEndOfTime: ->
    @endBeatTimer()
    @model.set 'new_player_one_time', $('#p1box .time').data("time")
    @model.set 'new_player_two_time', $('#p2box .time').data("time")
    @model.set 'active', false
    @model.trigger 'edit'

  resetState: =>
    @model.set 'new_player_one_time', 60
    @model.set 'new_player_two_time', 60
    @model.set 'active', false
    @model.trigger 'edit'
    @triggerSync()
