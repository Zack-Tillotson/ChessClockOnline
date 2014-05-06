ClockView = Backbone.View.extend
  tagName: '#theclock'

  initialize: ->
    @listenTo @model, 'change', @render

  sections:
    'player1-score'

  render: ->



