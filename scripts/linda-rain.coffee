# Description:
#   lindaで雨が降っているか確認する
#
# Commands:
#   hubot [where] 雨降ってる？
#
# Author:
#   @shokai


module.exports = (robot) ->

  robot.on 'linda:ready', (linda) ->

    robot.respond /([a-z_\-]+) 雨降ってる？/i, (msg) ->
      who = msg.message.user.name
      where = msg.match[1]

      linda.read_with_timeout linda.config.space,
        type: "rain"
        where: where
      , 2000, (err, tuple) ->
        if err
          return msg.send "@#{who} #{where}は知らない"

        if tuple.data.observation > 0
          msg.send "@#{who} 降ってる (#{tuple.data.observation})"
        else if tuple.data.forecast > 0
          msg.send "@#{who} 降ってないけど、もうすぐ降りそう (#{tuple.data.forecast})"
        else
          msg.send "@#{who} 降ってない"

