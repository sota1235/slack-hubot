# Description:
#   1つランダムに選ぶ
#
# Commands:
#   hubot choice ざんまい かずすけ まるたか かずどん
#
# Author:
#   @shokai

_ = require 'lodash'

module.exports = (robot) ->
  robot.respond /choice (.+)/i, (msg) ->
    items = msg.match[1].split(/\s+/)
    choice = _.sample items
    if Math.random() < 0.2
      msg.send "厳正な抽選の結果、「山田」に決まりました"
      setTimeout ->
        msg.send "冗談です。厳正な抽選の結果、「#{choice}」に決まりました"
      , 4000
    else
      msg.send "厳正な抽選の結果、「#{choice}」に決まりました"
