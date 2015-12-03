# Description:
#   lindaで明かりをつける
#
# Commands:
#   hubot [tuplespace] 電気(つけて|消して)
#
# Author:
#   @napo, @nikezono

module.exports = (robot) ->

  robot.on 'linda:ready', (linda) ->

    robot.respond /([a-z_\-]+) 電気(つけて|消して)/i, (msg) ->
      who = msg.message.user.name
      where = msg.match[1]
      cmd = switch msg.match[2]
        when "つけて" then "on"
        when "消して" then "off"

      linda.read_with_timeout linda.config.space,
        name: "light"
        cmd: cmd
        response: "success"
      , 5000, (err, tuple) ->
        if err
          msg.send "@#{who} ダメっぽい（失敗）"
          return
        msg.send switch cmd
          when "on" then "@#{who} つけたと思う"
          when "off" then "@#{who} 消したと思う"

      linda.tuplespace(linda.config.space).write
        name: "light"
        cmd: cmd
        where: where
      return

    robot.respond /(電気|light)/i, (msg) ->
      msg.send """
      hubotで電気をつける・消す
      (例)
      hubot delta 電気つけて
      hubot delta 電気消して
      """
      return
