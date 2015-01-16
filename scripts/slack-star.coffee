# Description:
#   notify "star_added" event for slack.com
#
# Author:
#   @shokai <hashimoto@shokai.org>

debug = require('debug')('hubot:slack-star')

module.exports = (robot) ->

  robot.adapter.client.on 'raw_message', (msg) ->
    return unless msg.type is 'star_added'
    debug msg
    return unless msg.item.message.permalink
    user = robot.adapter.client.getUserByID msg.user
    text = "@#{user.name} added star #{msg.item.message.permalink}"
    debug text
    robot.send {room: 'news'}, text
