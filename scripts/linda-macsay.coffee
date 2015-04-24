# Description:
#   lindaからMacのsayコマンドを使う
#
# Commands:
#   hubot [where] say おはよう
#
#   hubot say ごきげんよう
#
# Author:
#   @shokai


_ = require 'lodash'

module.exports = (robot) ->

  robot.on 'linda:ready', ->

    robot.respond /([a-z_\-]+) say (.+)$/i, (msg) ->
      where = msg.match[1]
      str = msg.match[2]
      robot.linda.tuplespace(robot.linda.config.space).write
        type: "say"
        value: str
        where: where
      msg.send "#{where}に「#{str}」って言っといてやったわ、感謝しなさい"


    robot.respond /say (.+)$/i, (msg) ->
      str = msg.match[1]
      robot.linda.tuplespace(robot.linda.config.space).write
        type: "say"
        value: str

      msg.send "「#{str}」って言っといてやったわ、感謝しなさい"
