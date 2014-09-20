# Description:
#   デプロイ通知
#
# Author:
#   @shokai


module.exports = (robot) ->

  robot.send {room: "#news"}, "Hubot、起動しました"
