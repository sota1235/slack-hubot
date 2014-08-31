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
  bots : [
    'http://hinagiku.geta6.net'
    'http://masuilab-hubot2.herokuapp.com'
    'http://babascript-hubot.herokuapp.com'
    'http://nikezono-hubot.herokuapp.com'
  ]


request   = require 'request'
{Promise} = require 'es6-promise'

monitorHubot = (bot_url) ->
  return new Promise (resolve, reject) ->
    url = "#{bot_url}/hubot/ping"
    request.post url, (err, res, body) ->
      promise_res = {
        statusCode: res.statusCode
        body: body
        url: url
      }
      if err or body isnt 'PONG'
        return reject promise_res
      return resolve promise_res


module.exports = (robot) ->

  robot.respond /monitor$/i, (msg) ->
    for bot in config.bots
      monitorHubot bot
      .then (res) ->
        msg.send "#{res.url} is ok"
      .catch (res) ->
        msg.send "#{config.headers.error} #{res.url} is not ok (statusCode:#{res.statusCode})\n```\n#{res.body}\n```"
