class @Clock extends Backbone.Model
  idAttribute: 'key'

  url: ->
    "/#{@get('key')}.json"

  initialize: ->
    @on 'edit', ->
      @save()
    @on 'sync', ->
      console.log "Model server sync!", @attributes

  status: ->
    if @get('is_game_over') or @is_game_over()
      "game_over"
    else if @get('active')
      "active"
    else
      "paused"

  is_game_over: ->
    @get('player_one_time') <= 0 or @get('player_two_time') <= 0
