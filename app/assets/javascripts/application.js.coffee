_ = require 'underscore'
$ = require  'jquery'
fullcalendar =  require 'fullcalendar'
h = require 'helpers'
ical = require 'ical'

console.log "HI THERE"

env = window.env = {}

$(document).ready ->
  console.log "READY!"
  calendar = env.calendar = (args...) ->
    el = $('#calendar')
    el.fullCalendar.apply el, args

  calendar {}

  _colors = [ "#B35982", "#9BC362", "#4F9D66", "#D4796A" ]

  color = window.color = ->
    ret = _colors.shift(); _colors.push ret
    ret

  $('#files').change (evt) ->
    files = evt.target.files
    _.each files, (file) ->
      if file.type isnt "text/calendar" then return console.error "wrong file type: #{file.type}"

      reader = new FileReader
      reader.onload = (e) ->
        ics = ical.parseICS(e.target.result)

        events = _.map (_.values _.omit ics, 'prodid'), (data) ->
          {
            title: data.summary
            allDay: true
            start: data.start
            end: data.end
          }

        calendar 'addEventSource', {
          events: events
          color: color()
        }

      reader.readAsText file
