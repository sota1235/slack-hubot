# Description:
#   hubot anonymous post
#
# Commands:
#   hubot anon MESSAGE
#   hubot anon #general MESSAGE
#
# Author:
#   @shokai

config =
  to: '#general'

module.exports = (robot) ->

  robot.respond /anon (#[a-zA-Z0-9_\-]+) (.+)$/i, (msg) ->
    from = msg.message.user.name
    to = msg.match[1].trim()
    text = msg.match[2].trim()
    robot.send to, text
    msg.send "@#{from} #{to}にこっそり「#{text}」って言っておきました"
    return

  robot.respond /anon (.+)$/i, (msg) ->
    from = msg.message.user.name
    text = msg.match[1].trim()
    robot.send config.to, text
    msg.send "@#{from} #{config.to}にこっそり「#{text}」って言っておきました"
    return

  robot.respond /anon$/i, (msg) ->
    msg.send """
    hubot anon MESSAGE
    hubot anon [to] MESSAGE
    hubot anon #general MESSAGE
    """
    return
