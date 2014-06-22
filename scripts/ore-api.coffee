# Description:
#   俺API - https://github.com/shokai/ore-api
#
# Commands:
#   hubot [NAME] (起きて|寝て)る？
#
# Author:
#   @shokai

config =
  url: 'https://ore-api.herokuapp.com'

module.exports = (robot) ->

  socket = require('socket.io-client').connect config.url

  socket.on 'connect', ->
    robot.send "#news", "socket.io 接続 - #{config.url}"

  socket.on 'sleep', (event) ->
    if event.action isnt 'creation'
      return
    robot.send "#news", "@#{event.screen_name} が眠りから覚めました"

  robot.respond /([a-z\d_\-]+) (起きて|寝て)る.*/i, (msg) ->
    from = msg.message.user.name
    who = msg.match[1]

    robot.http("#{config.url}/#{who}/status.json").get() (err, res, body) ->
      if err
        msg.send "@#{from} ore-apiエラー"
        return

      try
        data = JSON.parse body
      catch err
        msg.send "@#{from} ore-apiのjson parseエラー"
        return

      if data.error
        msg.send "@#{from} #{data.error} (#{who})"
        return

      status = switch data.status
        when "up"   then "間違いなく起きてる"
        when "down" then "寝てるかもしれない"
        else "わからない、不明なステータス (#{data.status})"

      msg.send "@#{from} #{who}、#{status}"
      return
