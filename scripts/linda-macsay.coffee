# Description:
#   lindaからMacのsayコマンドを使う
#
# Commands:
#   hubot [tuplespace] say おはよう
#
#   hubot say ごきげんよう
#
# Author:
#   @shokai


_ = require 'lodash'

module.exports = (robot) ->

  robot.on 'linda:ready', ->

    robot.respond /([a-z_\-]+) say ([^\s]+)/i, (msg) ->
      where = msg.match[1]
      str = msg.match[2]
      robot.linda.tuplespace(robot.linda.config.space).write
        type: "say"
        value: str
        where: where
      msg.send "#{where}に「#{str}」って言っといてやったわ、感謝しなさい"

    robot.respond /say ([^\s]+)/i, (msg) ->
      str = msg.match[1]
      for where, nickname of robot.linda.config.places
        robot.linda.tuplespace(robot.linda.config.space).write
          type: "say"
          value: str
          where: where
      to = _.keys(robot.linda.config.places).join("と")
      msg.send "#{to}に「#{str}」って言っといてやったわ、感謝しなさい"
