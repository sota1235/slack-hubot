# Description:
#   デプロイ通知
#
# Author:
#   @shokai


module.exports = (robot) ->

  cid = setInterval ->
    return if typeof robot?.send isnt 'function'
    robot.send {room: "news"}, "Hubot、起動しました"
    clearInterval cid
  , 1000

