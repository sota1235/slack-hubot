# Description:
#   UXと言われたら1000円と返す
#
# Author:
#   @shokai

module.exports = (robot) ->

  robot.hear /ux/i, (msg) ->

    who = msg.message.user.name
    msg.send "@#{who} UX1000円"
