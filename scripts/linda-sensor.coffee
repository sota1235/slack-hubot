# Description:
#   lindaでセンサー値を読む
#
# Commands:
#   hubot linda 温度
#
#   hubot linda 明るさ
#
# Author:
#   @shokai


module.exports = (robot) ->

  robot.on 'linda:ready', (linda) ->

    robot.respond /([a-z0-9_\-]+) 温度/i, (msg) ->
      where = msg.match[1]
      linda.read_with_timeout 'masuilab',
        type:  "sensor"
        name:  "temperature"
        where: where
      , 3000
      , (err, tuple) ->
        if err
          return msg.send "#{where}の温度 わからん度"
        tempe = Math.floor tuple.data.value
        msg.send "#{where}の温度 #{tempe}度"

    robot.respond /([a-z0-9_\-]+) 明るさ/i, (msg) ->
      where = msg.match[1]
      linda.read_with_timeout 'masuilab',
        type:  "sensor"
        name:  "light"
        where: where
      , 3000
      , (err, tuple) ->
        if err
          return msg.send "#{where}の明るさ 不明"
        light = Math.floor tuple.data.value
        msg.send "#{where}の明るさ #{light}"
