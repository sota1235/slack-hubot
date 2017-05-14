# Description:
#   lindaでドアを開ける
#
# Commands:
#   hubot [tuplespace] ドア(開けて|閉めて)
#
# Author:
#   @shokai

module.exports = (robot) ->

  robot.on 'linda:ready', (linda) ->

    robot.respond /([a-z_\-]+) ドア(開けて|閉めて)/i, (msg) ->
      who = msg.message.user.name
      where = msg.match[1]
      cmd = switch msg.match[2]
        when "開けて" then "open"
        when "閉めて" then "close"

      linda.read_with_timeout linda.config.space,
        type: "door"
        cmd: cmd
        who:who
        response: "success"
      , 5000, (err, tuple) ->
        if err
          msg.send "@#{who} ドアには・・勝てなかったよ（失敗）"
          return
        msg.send switch cmd
          when "open" then "@#{who} 開けたと思う"
          when "close" then "@#{who} 閉めたと思う"

      linda.tuplespace(linda.config.space).write
        type: "door"
        cmd: cmd
        who: who
        where: where
      return

    robot.respond /(ドア|door)/i, (msg) ->
      msg.send """
      hubotでドアを開ける・閉める
      (例)
      hubot delta ドア開けて
      hubot iota ドア閉めて
      """
      return
