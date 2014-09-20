# Description:
#   linda
#
# Commands:
#   hubot [NAME] (起きて|寝て)る？
#
#   hubot [NAME] 睡眠時間
#
# Author:
#   @shokai


config =
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
      robot.send {room: "#news"}, "linda-socket.ioに接続しました #{config.url}"

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
