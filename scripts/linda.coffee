config = {
  url: "http://node-linda-base.herokuapp.com"
}

module.exports = (robot) ->
  LindaClient = require('linda-socket.io').Client
  socket = require('socket.io-client').connect(config.url)
  robot.linda = linda = new LindaClient().connect(socket)

  robot.linda.config = config

  linda.io.on 'connect', ->
    robot.send {channel: "#news"}, "linda-socket.io(#{config.url})に接続しました"

  linda.read_with_timeout = (space_name, tuple, msec, callback = ->) ->
    ts = linda.tuplespace(space_name)
    cid = ts.read tuple, (err, tuple) ->
      cid = null
      callback(err, tuple)
    setTimeout ->
      ts.cancel cid if cid
    , msec

  robot.respond /linda/i, (msg) ->
    msg.send "lindaの設定 #{JSON.stringify robot.linda.config}"
