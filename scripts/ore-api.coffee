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

_     = require 'lodash'
debug = require('debug')('hubot-ore-api')

config =
  url: 'https://ore-api.herokuapp.com'
  slack:
    room: "#news"

module.exports = (robot) ->

  socket = require('socket.io-client').connect config.url

  if process.env.NODE_ENV isnt 'production'
    socket.on 'connect', ->
      debug "socket.io connect!!"
      robot.send {room: "#test"}, "socket.io 接続 - #{config.url}"

  get_activity = (type, screen_name, xid, callback = ->) ->
    robot.http("#{config.url}/#{screen_name}/#{type}.json?xid=#{xid}").get() (err, res, body) ->
      if err
        callback err
        return
      try
        data = JSON.parse body
      catch err
        callback err
        return
      debug data
      callback null, data.data
      return

  ## push from 俺API
  socket.on 'sleep', (event) ->
    debug "sleep - #{JSON.stringify event}"
    if event.action isnt 'creation'
      return
    robot.send config.slack, "@#{event.screen_name} が眠りから覚めました"
    get_activity "sleeps", event.screen_name, event.event_xid, (err, sleep) ->
      if err
        return
      txt = "睡眠時間 #{sleep.title}"
      if sleep.details.awakenings > 1
        txt += "\n#{sleep.details.awakenings}回の二度寝からがんばって起きました"
      robot.send config.slack, txt
      return

  notify_move = (event) ->
    get_activity "moves", event.screen_name, event.event_xid, (err, move) ->
      if err or move.details?.steps < 1
        debug 'no steps data in event'
        return
      current_steps = move.details.steps
      last_steps = robot.brain.get("steps_#{event.screen_name}") or 0
      robot.brain.set("steps_#{event.screen_name}", current_steps)
      if last_steps > current_steps
        last_steps = 0
      new_steps = current_steps - last_steps
      txt = if new_steps > 0
        "@#{event.screen_name} が#{new_steps}歩運動しました (本日合計#{current_steps}歩 #{move.details.km}km)"
      else
        txt = "@#{event.screen_name} が活発に活動しています"
      robot.send config.slack, txt

  # 60分に1回に間引く
  notify_move_throttled = _.throttle notify_move, 1000*60*60, trailing: false

  socket.on 'move', (event) ->
    debug "move - #{JSON.stringify event}"
    if event.action is 'updation'
      notify_move_throttled event


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
