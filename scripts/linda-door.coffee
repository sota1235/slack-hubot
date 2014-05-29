request = require 'request'
url = "http://node-linda-base.herokuapp.com"

module.exports = (robot) ->
  robot.respond /([a-z_\-]+) ドア(開けて|閉めて)/i, (msg) ->
    space = msg.match[1]
    cmd = switch msg.match[2]
      when "開けて" then "open"
      when "閉めて" then "close"

    post_data = {
      url: "#{url}/#{space}",
      form: {tuple: JSON.stringify({type: "door", cmd: cmd})}
    }
    request.post post_data, (err, res) ->
      if err
        msg.send "ドアには・・勝てなかったよ（失敗）"
        return
      msg.send switch cmd
        when "open" then "開けたと思う"
        when "close" then "閉めたと思う"
