# Description:
#   hubot-monitor-hubot
#
# Commands:
#   hubot monitor
#
# Author:
#   @shokai

config =
  interval : 20
  room: "news"
  headers :
    error: ':bangbang:'
  hubots : [
    'http://masuilab-hubot2.herokuapp.com'
    'http://babascript-hubot.herokuapp.com'
    'http://nikezono-hubot.herokuapp.com'
  ]


request   = require 'request'

monitorHubot = (bot_url, callback = ->) ->
  url = "#{bot_url}/hubot/ping"
  request.post url, (err, res, body) ->
    data =
      statusCode: res?.statusCode
      body: body or '(response body is empty)'
      url: bot_url

    if err
      return callback err, data
    if body isnt 'PONG'
      return callback true, data
    callback false, data

module.exports = (robot) ->

  robot.respond /monitor$/i, (msg) ->
    msg.send "monitoring #{config.hubots.length} hubots..."
    for bot in config.hubots
      monitorHubot bot, (err, res) ->
        unless err
          msg.send "#{res.url} is ok"
          return
        msg.send "#{config.headers.error} #{res.url} is not ok (statusCode:#{res.statusCode})\n```\n#{res.body}\n```"

  last_states = {}
  setInterval ->
    for bot in config.hubots
      monitorHubot bot, (err, res) ->
        bot_is_ok = !err
        if bot_is_ok isnt last_states[res.url]
          if bot_is_ok
            robot.send {room: config.room}, "#{res.url} is ok"
          else
            robot.send {room: config.room},
            "#{config.headers.error} #{res.url} is not ok (statusCode:#{res.statusCode})\n```\n#{res.body}\n```"
        last_states[res.url] = bot_is_ok
  , config.interval * 1000
