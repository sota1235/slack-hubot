# Description:
#   hubot-monitor-hubot
#
# Commands:
#   hubot monitor
#
# Author:
#   @shokai

request = require 'request'

config =
  headers :
    error: ':bangbang:'
  bots : [
    'http://hinagiku.geta6.net'
    'http://masuilab-hubot2.herokuapp.com'
    'http://babascript-hubot.herokuapp.com'
    'http://nikezono-hubot.herokuapp.com'
  ]

module.exports = (robot) ->

  robot.respond /monitor/i, (msg) ->
    for bot in config.bots
      do (bot) ->
        url = "#{bot}/hubot/ping"
        request.post url, (err, res, body) ->
          if err or body isnt 'PONG'
            msg.send "#{config.headers.error} #{bot} is not ok\n```\n#{body}\n```"
          else
            msg.send "#{bot} is ok"
