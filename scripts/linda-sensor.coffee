url = "http://node-linda-base.herokuapp.com"

LindaClient = require('linda-socket.io').Client
socket = require('socket.io-client').connect(url)
linda = new LindaClient().connect(socket)

read_with_timeout = (space_name, tuple, msec, callback = ->) ->
  ts = linda.tuplespace(space_name)
  cid = ts.read tuple, (err, tuple) ->
    cid = null
    callback(err, tuple)
  setTimeout ->
    ts.cancel cid if cid
  , msec


module.exports = (robot) ->

  linda.io.on 'connect', ->
    robot.send {channel: "#news"}, "linda-socket.io(#{url})に接続しました"

  robot.respond /([a-z0-9_\-]+) 温度/i, (msg) ->
    space_name = msg.match[1]
    read_with_timeout space_name, {type: "sensor", name: "temperature"}, 3000, (err, tuple) ->
      if err
        msg.send "#{space_name}の温度 わからん度"
        return
      tempe = Math.floor tuple.data.value
      msg.send "#{space_name}の温度 #{tempe}度"
