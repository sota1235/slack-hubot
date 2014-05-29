spawn = require('child_process').spawn
url = "http://node-linda-base.herokuapp.com/"

module.exports = (robot) ->
  robot.respond /(delta|iota) ドア開けて/i, (msg) ->
    child = spawn('/usr/bin/curl', ['-d', 'tuple={"type":"door","cmd":"open"}', url+msg.match[1]])
    child.stdout.on 'data', (data) ->
      msg.send "あけたと思う"

  robot.respond /delta 電気/i, (msg) ->
