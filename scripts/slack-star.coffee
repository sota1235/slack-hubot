# Description:
#   notify "star_added" event for slack.com
#
# Author:
#   @shokai <hashimoto@shokai.org>

debug = require('debug')('hubot:slack-star')
_     = require 'lodash'

config =
  room: 'stars'

module.exports = (robot) ->

  stars =
    prefix: "slackstar"
    get: (url) ->
      robot.brain.get("#{@prefix}_#{url}") or []
    set: (url, users) ->
      return unless users instanceof Array
      robot.brain.set "#{@prefix}_#{url}", users
    add: (url, user) ->
      users = @get url
      users.push user
      @set url, _.uniq(users)
    remove: (url, user) ->
      users = @get url
      users.splice(users.indexOf(user), 1)
      @set url, users

  robot.adapter.client?.on? 'raw_message', (msg) ->
    return if ['star_added', 'star_removed'].indexOf(msg.type) < 0
    debug msg
    return unless url  = msg.item.message.permalink
    return unless user = robot.adapter.client.getUserByID msg.user
    origin =
      body: decodeURI(msg.item.message.text).replace(/<(https?:\/\/[^<>\|\s]+)(\|[^<>]+)?>/gmi, '$1')
      user: robot.adapter.client.getUserByID msg.item.message.user
    switch msg.type
      when 'star_added'
        stars.add url, user.name
        users = stars.get url
        text = "#{[0...users.length].map(-> ":star:").join ''} #{url} by #{users.join ','}"
        if users.length > 1
          quoted_body = "#{origin.user.name}: #{origin.body}".split(/[\r\n]/).map((i) -> "> #{i}").join('\n')
          text = "#{text}\n#{quoted_body}"
        debug text
        robot.send {room: config.room}, text
      when 'star_removed'
        stars.remove url, user.name
