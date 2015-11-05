# Description:
#   notify "reaction_added" event for slack.com
#
# Author:
#   @shokai <hashimoto@shokai.org>

debug = require('debug')('hubot:slack-reaction')
_     = require 'lodash'

config =
  room: 'stars'

module.exports = (robot) ->

  reactions =
    prefix: "reaction"
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
    if msg.type isnt 'reaction_added' and
       msg.type isnt 'reaction_removed'
      return
    debug msg
    return if msg.item.type isnt 'message'
    return unless channel = robot.adapter.client.getChannelByID msg.item.channel
    return unless user = robot.adapter.client.getUserByID msg.user
    url = "https://#{robot.adapter.client.team.domain}.slack.com/archives/#{channel.name}/p#{msg.item.ts.replace('.','')}"
    switch msg.type
      when 'reaction_added'
        reactions.add url, user.name
        users = reactions.get url
        text = "#{[0...users.length].map(-> ":#{msg.reaction}:").join ''} #{url} by #{users.join ','}"
        debug text
        robot.send {room: config.room}, text
      when 'reaction_removed'
        reactions.remove url, user.name
