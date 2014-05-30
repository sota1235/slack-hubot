_ = require 'lodash'

module.exports = (robot) ->
  robot.respond /([a-z_\-]+) say ([^\s]+)/i, (msg) ->
    space = msg.match[1]
    str = msg.match[2]
    robot.linda.tuplespace(space).write {type: "say", value: str}
    msg.send "#{space}に「#{str}」って言っといてやったわ、感謝しなさい"

  robot.respond /say ([^\s]+)/i, (msg) ->
    str = msg.match[1]
    for name, yomi of robot.linda.config.spaces
      robot.linda.tuplespace(name).write {type: "say", value: str}
    to = _.keys(robot.linda.config.spaces).join("と")
    msg.send "#{to}に「#{str}」って言っといてやったわ、感謝しなさい"
