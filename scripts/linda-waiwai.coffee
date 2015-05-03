# Description:
#   lindaでwaiwai度を読む
#
# Commands:
#   hubot linda わいわい
#
# Author:
#   @shokai


module.exports = (robot) ->

  robot.on 'linda:ready', (linda) ->

    robot.respond /([a-z0-9_\-]+) わいわい/i, (msg) ->
      where = msg.match[1]
      linda.read_with_timeout 'masuilab',
        type:  "waiwai"
        where: where
      , 3000
      , (err, tuple) ->
        if err
          return msg.send "#{where}、たぶんわいわいしてない。心は無です"
        percent = tuple.data.percent
        if percent > 95
          msg.send "#{where}、わいわいしすぎて気絶 (#{percent}%)"
        else
          msg.send "#{where}、わいわいしてる (#{percent}%)"
