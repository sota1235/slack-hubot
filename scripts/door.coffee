spawn = require('child_process').spawn

module.exports = (robot) ->
  robot.respond /delta ドア開けて/i, (msg) ->
    url = "http://node-linda-base.herokuapp.com/delta"
    child = spawn('/usr/bin/curl', ['-d', 'tuple={"type":"door","cmd":"open"}', url])
    child.stdout.on 'data', (data) ->
      msg.send "あけたと思う"
