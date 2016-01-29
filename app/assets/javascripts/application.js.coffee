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

login = (callback) ->
  login = $('.loader')

  if window.user
    renderUser()
    $('.login').addClass "loggedin"
    $('.login').show()
    callback()

  else
    $('.login').addClass "animSlow"
    $('.login').show()

    login.one 'click', (e) ->
      popupCenter "/auth/facebook", 700, 700, "facebook login"
      login.css opacity: 0
      h.wait 500, ->
        login.html("<i class='fa fa-spinner fa-pulse' />")
        login.css opacity: 1

      e.stopPropagation()
      return false

    window.loggedin = (user) ->
      window.user = user
      console.log "GOT USER", user
      login.css opacity: 0
      h.wait 500, ->
        renderUser()
        login.css opacity: 1
        h.wait 1000, ->
          $('.login').addClass('loggedin')
          h.wait 1000, callback

renderUser = ->
  $('.loader').html("<img class='avatar' src='#{user.image}' /><div class='text'>#{user.name}</div>")
  $('.loader').click -> document.location = '/logout'


calendar = ->
  $('.main').fadeIn()

  calendar = env.calendar = (args...) ->
    el = $('.calendar')
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
            start: data.start
            end: data.end
            allDay: true
          }

        calendar 'addEventSource', {
          events: events
          color: color()
        }

      reader.readAsText file

$(document).ready ->
  login -> calendar()
