# Description:
#   hubot-monitor-hubot
#
# Commands:
#   hubot monitor
#
# Author:
#   @shokai

request = require 'request'

bots = [
  'http://hinagiku.geta6.net/'
  'http://masuilab-hubot2.herokuapp.com/'
  'http://babascript-hubot.herokuapp.com/'
  'http://nikezono-hubot.herokuapp.com/'
]

module.exports = (robot) ->

  robot.respond /monitor/i, (msg) ->
    for bot in bots
      do (bot) ->
        request.head bot, (err, res) ->
          if err
            msg.send "#{bot} not respond"
          else
            msg.send "#{bot} is ok"
