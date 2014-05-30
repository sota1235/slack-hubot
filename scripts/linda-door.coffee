module.exports = (robot) ->
  robot.respond /([a-z_\-]+) ドア(開けて|閉めて)/i, (msg) ->
    space = msg.match[1]
    cmd = switch msg.match[2]
      when "開けて" then "open"
      when "閉めて" then "close"

    robot.linda.read_with_timeout space, {type: "door", cmd: cmd, response: "success"}, 5000, (err, tuple) ->
      if err
        msg.send "ドアには・・勝てなかったよ（失敗）"
        return
      msg.send switch cmd
        when "open" then "開けたと思う"
        when "close" then "閉めたと思う"

    robot.linda.tuplespace(space).write {type: "door", cmd: cmd}
