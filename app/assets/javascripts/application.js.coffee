_ = require 'underscore'
$ = require  'jquery'
fullcalendar =  require 'fullcalendar'
h = require 'helpers'
ical = require 'ical'

env = window.env = {}
popupCenter = (url, width, height, name) ->
  left = (screen.width/2)-(width/2);
  top = (screen.height/2)-(height/2);
  window.open url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top

window.loggedin = ->
  console.log "LOGGEDIN!"

$(document).ready ->
  console.log "LALA"
  $('.login').click (e) ->
    popupCenter "/auth/facebook", 500, 500, "facebook login"

    login = $('.login')
    login.css opacity: 0
    h.wait 500, ->
      login.html("<i class='fa fa-spinner fa-pulse' />")
      login.css opacity: 1

    e.stopPropagation()
    return false


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
