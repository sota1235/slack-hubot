# Description:
#   linda
#
# Dependencies:
#   "debug": "*"
#
# Commands:
#
# Author:
#   @shokai

debug = require('debug')('hubot:linda')

config =
  channel: '#news'
  header: ':feelsgood:'
  url: "https://linda-server.herokuapp.com"
  space: "masuilab"  # main
  spaces :
    delta : "デルタ"  # 名前と読み仮名
    iota  : "イオタ"
    tau   : "タウ"
    shokai: "しょうかいハウス"

module.exports = (robot) ->
  LindaClient = require('linda').Client
  socket = require('socket.io-client').connect(config.url)
  robot.linda = linda = new LindaClient().connect(socket)

  robot.linda.config = config

  if process.env.NODE_ENV isnt 'production'
    linda.io.on 'connect', ->
      cid = setInterval ->
        return if typeof robot?.send isnt 'function'
        robot.send {room: "news"}, "linda-socket.ioに接続しました #{config.url}"
        clearInterval cid
      , 1000

  linda.read_with_timeout = (space_name, tuple, msec, callback = ->) ->
    ts = linda.tuplespace(space_name)
    cid = ts.read tuple, (err, tuple) ->
      cid = null
      callback(err, tuple)
    setTimeout ->
      if cid
        ts.cancel cid
        callback "timeout"
    , msec

  robot.respond /linda/i, (msg) ->
    msg.send "lindaの設定 #{JSON.stringify robot.linda.config}"

  ts = linda.tuplespace config.space
  ts.watch {type: "slack", cmd: "post"}, (err, tuple) ->
    return if tuple.data.response?
    return unless tuple.data.value?
    debug tuple
    unless channel = tuple.data.channel or config.channel
      tuple.data.response = "fail"
      ts.write tuple.data
      return
    msg = "#{config.header} <Linda/#{ts.name}> #{tuple.data.value}"

    robot.send {room: channel}, msg
    tuple.data.response = 'success'
    ts.write tuple.data
