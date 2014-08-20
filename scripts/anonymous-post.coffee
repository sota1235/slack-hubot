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

  robot.respond /anon (.+)$/i, (msg) ->
    from = msg.message.user.name
    args = msg.match[1].trim().split(/\s+/)
    if /[#@][a-zA-Z0-9_\-]+/.test args[0]
      to = args.shift()
    else
      to = config.to
    text = args.join(' ')
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
