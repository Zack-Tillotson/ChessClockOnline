$ ->

  pusher = new Pusher '13988d5e9c7c21cbbbcf' # Set up pusher lib

  if not _.isEmpty(key = $('#theclock').data('key'))

    window.clock = new Clock(key: key)
    window.clockview = new ClockView(model: clock, el: $('#theclock'))
    clock.fetch()

