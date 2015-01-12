# Description:
#   腹が減ったらカレーメシ
#
# Author:
#   @shokai

_ = require 'lodash'

texts = [
  'カレーメシ！！'
  'ボーキメシ！！'
  'ジャッスティス！！！'
  'http://www.currymeshi.com'
  'http://gyazo.com/fc6c4a6f74d41ee472948c35d7ab1d45.png'
  'http://gyazz.masuilab.org/upload/98ae3c672184b9692f7e454efc6ebcc6.mp3'
  'https://www.youtube.com/watch?v=vhSBtoviSKw'
]

module.exports = (robot) ->

  reply = (msg) ->

    who = msg.message.user.name
    text = _.sample texts
    msg.send "@#{who} #{text}"

  robot.hear /カレー/i, reply
  robot.hear /curry/i, reply
  robot.hear /(おなか|ハラ|はら|腹)/i, reply
