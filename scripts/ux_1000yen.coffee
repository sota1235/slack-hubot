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

  register_censor = (word) ->
    robot.hear new RegExp( word.split('').join('.*'), 'i' ), reply

  register_censor 'ユザエクスペリエンス'
  register_censor 'ユザ体験'
  register_censor 'userexperience'
