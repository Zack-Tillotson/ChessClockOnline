class @Clock extends Backbone.Model
  idAttribute: 'key'

  url: ->
    "/#{@get('key')}.json"

  initialize: ->
    @on 'edit', ->
      @save()
    @on 'sync', ->
      @unset 'new_player_one_time'
      @unset 'new_player_two_time'
      console.log "Model server sync!", @attributes
      console.log @status()

  status: ->
    if @get('is_game_over') or @is_game_over()
      "game_over"
    else if @get('active')
      "active"
    else
      "paused"

  is_game_over: ->
    @get('player_one_time') <= 0 or @get('player_two_time') <= 0
