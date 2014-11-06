# Description:
#   UXと言われたら1000円と返す
#
# Author:
#   @shokai

module.exports = (robot) ->

  reply = (msg) ->

    who = msg.message.user.name
    msg.send "@#{who} UX1000円"

  robot.hear /ux/i, reply
  robot.hear new RegExp('ユザエクスペリエンス'.split('').join('.*')), reply
