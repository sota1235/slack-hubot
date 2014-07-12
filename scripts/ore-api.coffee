# Description:
#   俺API - https://github.com/shokai/ore-api
#
# Commands:
#   hubot [NAME] (起きて|寝て)る？
#
#   hubot [NAME] 睡眠時間
#
# Author:
#   @shokai

_ = require 'lodash'

config =
  url: 'https://ore-api.herokuapp.com'
  slack:
    room: "#news"

module.exports = (robot) ->

  socket = require('socket.io-client').connect config.url

  if process.env.NODE_ENV isnt 'production'
    socket.on 'connect', ->
      robot.send {room: "#test"}, "socket.io 接続 - #{config.url}"

  ## push from 俺API
  socket.on 'sleep', (event) ->
    if event.action isnt 'creation'
      return
    robot.send config.slack, "@#{event.screen_name} が眠りから覚めました"

  notify_move = (event) ->
    if event.action isnt 'updation'
      return
    robot.send config.slack, "@#{event.screen_name} が活発に活動しています"

  # 1時間に1回に間引く
  notify_move_throttled = _.throttle notify_move, 1000*60*60, trailing: false

  socket.on 'move', notify_move_throttled


  ## slack chat event
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


  robot.respond /([a-z\d_\-]+) 睡眠/i, (msg) ->
    from = msg.message.user.name
    who = msg.match[1]

    robot.http("#{config.url}/#{who}/sleeps.json").get() (err, res, body) ->
      if err
        return msg.send "@#{from} ore-api エラー"

      try
        data = JSON.parse body
      catch err
        return msg.send "@#{from} ore-apiのjson parseエラー"

      day = 3
      total = 0
      for sleep in data.data.items
        if sleep.time_updated > Date.now()/1000 - 60*60*24*day
          total += sleep.details.awake_time - sleep.details.asleep_time

      total = Math.floor(total/60/60)
      txt = "@#{who}はここ#{day}日で#{total}時間寝ています"
      if total < day*6  # せめて6時間睡眠
        txt += "\nもう少し寝た方がいい"
      return msg.send txt
