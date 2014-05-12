class @Clock extends Backbone.Model
  idAttribute: 'key'

  url: ->
    "/#{@get('key')}.json"

  initialize: ->
    @on 'edit', ->
      @save()
    @on 'sync', ->
      console.log "Model server sync!", @attributes
