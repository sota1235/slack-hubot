# Description:
#   hubot-monitor-hubot
#
# Commands:
#   hubot monitor
#
# Author:
#   @shokai

config =
  headers :
    error: ':bangbang:'
  hubots : [
    'http://hinagiku.geta6.net'
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
      url: url

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
