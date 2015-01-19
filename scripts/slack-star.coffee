# Description:
#   notify "star_added" event for slack.com
#
# Author:
#   @shokai <hashimoto@shokai.org>

debug = require('debug')('hubot:slack-star')

config =
  room: 'stars'

module.exports = (robot) ->

  robot.adapter.client?.on? 'raw_message', (msg) ->
    switch msg.type
      when 'star_added'
        debug msg
        return unless msg.item.message.permalink
        user = robot.adapter.client.getUserByID msg.user
        text = ":star: @#{user.name} added star #{msg.item.message.permalink}"
        debug text
        robot.send {room: config.room}, text
      when 'star_removed'
        debug msg
        ## 流したstar通知を削除したかったけどAPIがない
